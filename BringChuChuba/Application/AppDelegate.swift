//
//  AppDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit
import Firebase
import Alamofire

import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        loginAndCheckToken()

        return true
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

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
