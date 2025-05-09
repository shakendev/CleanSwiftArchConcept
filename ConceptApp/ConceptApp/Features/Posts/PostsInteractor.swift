import Foundation

protocol PostsDataStore {
    var id: Int? { get }
}

@MainActor
protocol PostsBusinessLogic: AnyObject {
    func loadPosts(with request: PostsModel.FetchPosts.Request)
    func selectPost(by id: Int)
}

final class PostsInteractor: PostsDataStore {
    var presenter: (any PostsPresentationLogic)?

    private(set) var id: Int?
}

extension PostsInteractor: PostsBusinessLogic {
    func loadPosts(with request: PostsModel.FetchPosts.Request) {
        // FIXME: - move to post worker n' add DIP abstraction, add network manager, extract DTO to API folder
        Task(priority: .background) {
            guard
                let url = URL(string: "https://dummyjson.com/posts"),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let dto = try? JSONDecoder().decode(PostsDTO.self, from: data)
            else { return }

            await MainActor.run {
                let response = dto.mapToResponse()

                presenter?.presentPosts(with: response)
            }
        }
    }

    func selectPost(by id: Int) {
        self.id = id
    }
}

struct PostsDTO: Decodable {
    let posts: [Post]
}

extension PostsDTO {
    struct Post: Decodable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
}

extension PostsDTO {
    func mapToResponse() -> PostsModel.FetchPosts.Response {
        let posts = posts.map {
            PostsModel.FetchPosts.Response.Post(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body)
        }

        return .init(posts: posts)
    }
}
