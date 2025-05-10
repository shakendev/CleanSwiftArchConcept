import Foundation

@MainActor
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
    private let worker: (any PostsWorkingLogic) = PostsWorker()
}

extension PostsInteractor: PostsBusinessLogic {
    func loadPosts(with request: PostsModel.FetchPosts.Request) {
        Task(priority: .background) {
            guard let response = await worker.loadPosts() else { return }

            await MainActor.run {
                presenter?.presentPosts(with: response)
            }
        }
    }

    func selectPost(by id: Int) {
        self.id = id
    }
}
