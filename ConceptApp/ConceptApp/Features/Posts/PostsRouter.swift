import UIKit

protocol PostsDataPassing: AnyObject {
    var dataStore: (any PostsDataStore)? { get }
}

@MainActor
protocol PostsRoutingLogic: AnyObject {
    func routeToPost()
}

final class PostsRouter: PostsDataPassing {
    weak var screen: PostsScreen?
    var dataStore: (any PostsDataStore)?
}

extension PostsRouter: PostsRoutingLogic {
    func routeToPost() {
        guard let screen, let dataStore else { return }

        let postScreen = PostScreen()
        var postDataStore = postScreen.router?.dataStore

        postDataStore?.id = dataStore.id

        screen.navigationController?.pushViewController(postScreen, animated: true)
    }
}
