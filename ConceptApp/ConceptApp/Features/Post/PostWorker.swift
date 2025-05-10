import MelonKit

@MainActor
protocol PostWorkingLogic: AnyObject {
    func loadPost(with id: Int) async -> PostModel.FetchPost.Response?
}

final class PostWorker: PostWorkingLogic {
    private let config = NetworkConfig()
    private let network = MLNNetworkManager(disconnectWhenVPNIsEnabled: true)

    func loadPost(with id: Int) async -> PostModel.FetchPost.Response? {
        let path = "\(id)"
        guard let url = config.getURL(for: .posts, appending: path) else { return nil }

        let dto: PostDTO? = try? await network.request(.get, timeout: 30, for: url, with: [], using: nil)

        return dto?.mapToResponse()
    }
}
