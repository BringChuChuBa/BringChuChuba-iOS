//
//  SceneDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit
import RxSwift

import Firebase
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var mainCoordinator: MainCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseApp.configure()
        loginAndCheckToken()
        // getMember()

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)

        mainCoordinator = MainCoordinator(window: self.window!)
        mainCoordinator.start()
    }

    private func loginAndCheckToken() {
        var finished = false

        Auth.auth().signInAnonymously { result, error in
            guard error.isNone else {
                return
            }

            guard let user = result?.user else {
                // 여기도 재시도 해보고 에러 처리
                print("\(#file) Firebase SignIn Fail")
                fatalError()
            }

            user.getIDTokenForcingRefresh(false) { token, error in
                guard error.isNone else {
                    return
                }

                guard let authToken = token else {
                    return
                }

                GlobalData.shared.userToken = authToken

                finished = true
            }
        }

        while !finished {
            RunLoop.current.run(
                mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"),
                before: NSDate.distantFuture
            )
        }

        return
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
