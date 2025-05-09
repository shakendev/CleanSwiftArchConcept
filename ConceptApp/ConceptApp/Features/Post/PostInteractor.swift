import Foundation

protocol PostDataStore {
    var id: Int? { get set }
}

@MainActor
protocol PostBusinessLogic: AnyObject {
    func loadPost(with request: PostModel.FetchPost.Request)
}

final class PostInteractor: PostDataStore {
    var id: Int?
    
    var presenter: (any PostPresentationLogic)?
}

extension PostInteractor: PostBusinessLogic {
    func loadPost(with request: PostModel.FetchPost.Request) {
        // FIXME: - move to post worker n' add DIP abstraction, add network manager, extract DTO to API folder
        guard let id else { return }

        Task(priority: .background) {
            guard
                let url = URL(string: "https://dummyjson.com/posts/\(id)"),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let dto = try? JSONDecoder().decode(PostDTO.self, from: data)
            else { return }

            await MainActor.run {
                let response = dto.mapToResponse()

                presenter?.presentPost(with: response)
            }
        }
    }
}

struct PostDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension PostDTO {
    func mapToResponse() -> PostModel.FetchPost.Response {
        .init(userId: userId, id: id, title: title, body: body)
    }
}
