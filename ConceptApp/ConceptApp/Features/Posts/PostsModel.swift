import Foundation

enum PostsModel { }

extension PostsModel {
    enum FetchPosts { }
}

extension PostsModel.FetchPosts {
    struct Request { }
}

extension PostsModel.FetchPosts {
    struct Response {
        let posts: [Post]
    }
}

extension PostsModel.FetchPosts.Response {
    struct Post {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
}

extension PostsModel.FetchPosts {
    struct ViewItems {
        let posts: [Post]
    }
}

extension PostsModel.FetchPosts.ViewItems {
    struct Post {
        let userID: Int
        let id: Int
        let title: String
        let body: String
    }
}
