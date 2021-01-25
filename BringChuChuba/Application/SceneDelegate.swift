//
//  SceneDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit
import Then
import RxSwift
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseApp.configure()

        anonymouslyLogin()
        getMember()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)

        appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator.start()
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

// MARK: Firebase Login
extension SceneDelegate {
    private func anonymouslyLogin() {
        var finished = false

        Auth.auth().signInAnonymously { result, error in
            guard error.isNone else {
                return
            }

            guard (result?.user).isSome else {
                // 여기도 재시도 해보고 에러 처리
                print("\(#file) Firebase SignIn Fail")
                fatalError()
            }

            finished = true
        }

        while !finished {
            RunLoop.current.run(
                mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"),
                before: NSDate.distantFuture
            )
        }

        return
    }

    private func getMember() {
        var finished = false

        _ = Network.shared.request(with: .getMember,
                                   for: Member.self)
            .subscribe { member in
                GlobalData.shared.id = member.id
                GlobalData.shared.do {
                    if let familyId = member.familyId { $0.familyId = familyId }
                    if let point = member.point { $0.point = point }
                    if let nickname = member.nickname { $0.nickname = nickname }
                }

                finished = true
            } onError: { _ in
                finished = true
            }

        while !finished {
            RunLoop.current.run(
                mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"),
                before: NSDate.distantFuture
            )
        }

        return
    }
}
