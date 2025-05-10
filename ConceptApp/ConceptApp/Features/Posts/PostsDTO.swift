import Foundation

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
