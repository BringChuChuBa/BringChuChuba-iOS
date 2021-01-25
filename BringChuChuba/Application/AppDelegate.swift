//
//  AppDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseOptions.defaultOptions()?.deepLinkURLScheme // = self.customURLScheme
//        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate {
    // MARK: DeepLink Parser
    // iOS 9 이상 버전에 앱을 이미 설치
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let webpageURL = userActivity.webpageURL else { return false }

        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL) { (dynamiclink, error) in
            guard error.isNone else { return }

            if let dynamicLink = dynamiclink {
                self.handleInComingDynamicLink(dynamicLink)
            }
        }

        return handled
    }

    // 앱의 커스텀 URL 스키마를 통해 수신된 링크를 처리
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        self.handleInComingDynamicLink(dynamicLink)

        return true
      }
      return false
    }

    // MARK: DeepLink Handle Method
    func handleInComingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("No URL !!! ")
            return
        }

        print("incoming link \(url.absoluteString)")

        guard dynamicLink.matchType == .unique || dynamicLink.matchType == .default else {
            print("Not a strong enough math type")
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems  else { return }

        if components.path == "recipes" {
            if let recipeQueryItem = queryItems.first(where: { $0.name == "recipeID" }) {
                guard let recipeID = recipeQueryItem.value else { return }
                print("recipeID = \(recipeID)")
            }

            // 여기서 joinFamily 하면 될듯!
            // go to VC
        }
    }
}

extension AppDelegate {
//    // MARK: Private Methods
//    private func anonymouslyLogin() {
//        var finished = false
//
//        Auth.auth().signInAnonymously { result, error in
//            guard error.isNone else {
//                return
//            }
//
//            guard (result?.user).isSome else {
//                // 여기도 재시도 해보고 에러 처리
//                print("\(#file) Firebase SignIn Fail")
//                fatalError()
//            }
//
//            finished = true
//        }
//
//        while !finished {
//            RunLoop.current.run(
//                mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"),
//                before: NSDate.distantFuture
//            )
//        }
//
//        return
//    }
//
//    private func getMember() {
//        var finished = false
//
//        _ = Network.shared.request(with: .getMember,
//                                   for: Member.self)
//            .subscribe { member in
//
//                GlobalData.shared.id = member.id
//                GlobalData.shared.do {
//                    if let familyId = member.familyId { $0.familyId = familyId }
//                    if let point = member.point { $0.point = point }
//                    if let nickname = member.nickname { $0.nickname = nickname }
//                }
//
//                finished = true
//            } onError: { _ in
//                finished = true
//            }
//
//        while !finished {
//            RunLoop.current.run(
//                mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"),
//                before: NSDate.distantFuture
//            )
//        }
//
//        return
//    }
}
