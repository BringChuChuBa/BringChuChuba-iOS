//
//  AppDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit

import Firebase
import RxSwift
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // window
        window = UIWindow()
        window?.backgroundColor = .white

        // image picker
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }

        // signin
        FirebaseApp.configure()

        Network.shared.fetchToken { [weak self] token in
            guard let self = self else { return }
            self.fetchCurrentMember(with: token)
        }

        // to test
//        fetchCurrentMember(with: "")

        return true
    }
}

// MARK: FirebaseAuth
// AuthManager
extension AppDelegate {
    private func fetchCurrentMember(with token: String) {
        // member
        _ = Network.shared.request(with: .getMember,
                                   for: Member.self)
            .subscribe(onSuccess: { [weak self] member in
                guard let self = self else { return }

                GlobalData.shared.do {
                    $0.id = member.id
                    $0.point = member.point
                    if let familyId = member.familyId { $0.familyId = familyId }
                    if let nickname = member.nickname { $0.nickname = nickname }
                }

                self.appCoordinator = AppCoordinator(window: self.window!)
                self.appCoordinator.start()
            }, onError: { error in
                print(error.localizedDescription)
                return
            })
    }
}

/*
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

        if components.path == "/invite" { // 안되면 invite
            if let familyQueryItem = queryItems.first(where: { $0.name == "familyId" }) {
                guard let familyId = familyQueryItem.value else { return }
                print("familyId = \(familyId)")
            }

            // 여기서 joinFamily 하면 될듯!
            // go to VC
        }
    }
}
*/
