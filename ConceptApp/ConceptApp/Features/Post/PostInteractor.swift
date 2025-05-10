import Foundation

@MainActor
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
    private let worker: (any PostWorkingLogic) = PostWorker()
}

extension PostInteractor: PostBusinessLogic {
    func loadPost(with request: PostModel.FetchPost.Request) {
        guard let id else { return }

        Task(priority: .background) {
            guard let response = await worker.loadPost(with: id) else { return }

            await MainActor.run {
                presenter?.presentPost(with: response)
            }
        }
    }
}
