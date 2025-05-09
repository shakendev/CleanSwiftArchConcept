import Foundation

@MainActor
protocol PostsPresentationLogic: AnyObject {
    func presentPosts(with response: PostsModel.FetchPosts.Response)
}

final class PostsPresenter {
    weak var screen: (any PostsDisplayLogic)?
}

extension PostsPresenter: PostsPresentationLogic {
    func presentPosts(with response: PostsModel.FetchPosts.Response) {
        let posts = response.posts.map {
            PostsModel.FetchPosts.ViewItems.Post(userID: $0.userId, id: $0.id, title: $0.title, body: $0.body)
        }
        let items = PostsModel.FetchPosts.ViewItems(posts: posts)

        screen?.displayPosts(with: items)
    }
}
