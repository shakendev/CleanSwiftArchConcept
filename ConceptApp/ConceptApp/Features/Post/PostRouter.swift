import UIKit

protocol PostDataPassing: AnyObject {
    var dataStore: (any PostDataStore)? { get }
}

@MainActor
protocol PostRoutingLogic: AnyObject {
    func routeBackToPosts()
}

final class PostRouter: PostDataPassing {
    weak var screen: PostScreen?
    var dataStore: (any PostDataStore)?
}

extension PostRouter: PostRoutingLogic {
    func routeBackToPosts() {
        screen?.navigationController?.popViewController(animated: true)
    }
}
