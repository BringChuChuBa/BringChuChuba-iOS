//
//  AppDelegate.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/03.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else {
                print("\(#file) Firebase SignIn Fail")
                fatalError()
            }
            user.getIDTokenForcingRefresh(true) { (idToken, error) in
                if error != nil {
                    print("\(#file) Firebase getIDToken Fail")
                    fatalError()
                }
                GlobalData.sharedInstance().userToken = idToken
                print("\(idToken)")

                // getMyInfo
                APIClient.getMember(completion: { result in
                    switch result {
                    case .success(let member):
                        print(member)
                    case .failure(let error):
                        print(error)
                    }
                })

                // getFamily
                let familyId = 1
                APIClient.getFamily(familyId: familyId, completion: { result in
                    switch result {
                    case .success(let family):
                        print(family)
                    case .failure(let error):
                        print(error)
                    }
                })

                // TODO: createFamily
                // TODO: joinFamily
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
