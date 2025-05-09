//
//  SceneDelegate.swift
//  ConceptApp
//
//  Created by Dimka Novikov on 09.05.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let rootViewController = PostsScreen()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
