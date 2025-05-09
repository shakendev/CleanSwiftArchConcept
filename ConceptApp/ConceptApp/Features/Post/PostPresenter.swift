import Foundation

@MainActor
protocol PostPresentationLogic: AnyObject {
    func presentPost(with response: PostModel.FetchPost.Response)
}

final class PostPresenter {
    weak var screen: (any PostDisplayLogic)?
}

extension PostPresenter: PostPresentationLogic {
    func presentPost(with response: PostModel.FetchPost.Response) {
        let items = PostModel.FetchPost.ViewItems(
            userId: response.userId,
            id: response.id,
            title: response.title,
            body: response.body
        )

        screen?.displayPost(with: items)
    }
}
