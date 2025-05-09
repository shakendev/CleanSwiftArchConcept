import Foundation

enum PostModel { }

extension PostModel {
    enum FetchPost { }
}

extension PostModel.FetchPost {
    struct Request { }
}

extension PostModel.FetchPost {
    struct Response {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
}

extension PostModel.FetchPost {
    struct ViewItems {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
}
