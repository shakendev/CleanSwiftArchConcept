import MelonKit

@MainActor
protocol PostsWorkingLogic: AnyObject {
    func loadPosts() async -> PostsModel.FetchPosts.Response?
}

final class PostsWorker: PostsWorkingLogic {
    private let config = NetworkConfig()
    private let network = MLNNetworkManager(disconnectWhenVPNIsEnabled: true)

    func loadPosts() async -> PostsModel.FetchPosts.Response? {
        guard let url = config.getURL(for: .posts) else {
            return nil
        }

        let dto: PostsDTO? = try? await network.request(.get, timeout: 30, for: url, with: [], using: nil)

        return dto?.mapToResponse()
    }
}
