//
//  SceneDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let initialVC: MainTabBarController = MainTabBarController()

        // FIXME: Coordinator에 대한 설정은 didFinish~~에서 하는게 맞는 것인가 여기서 하는게 맞는것인가?
        // send that into our coordinator so that it can display view controllers
        coordinator = MainCoordinator()

        // tell the coordinator to take over control
        coordinator?.start()

        // create a basic UIWindow and activate it
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
