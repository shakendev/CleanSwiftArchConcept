import Foundation

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
