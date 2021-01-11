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

        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                // 여기도 재시도 해보고 에러 처리
                print("\(#file) Firebase SignIn Fail")
                fatalError()
            }

            user.getIDTokenForcingRefresh(false) { idToken, error in
                if let error = error {
                    print("\(#file) Firebase getIDToken Fail")
                    print("error: \(error.localizedDescription)")
                    // 타임아웃, 네트워크 연결 요청 처리
                }

                GlobalData.shared.userToken = idToken
                // getMyInfo
                APIClient.shared.getMember { result, error  in
                    guard error.isNone else {
                        print(error!.localizedDescription)
                        return
                    }

                    guard let member = result else {
                        print("Member is nil")
                        return
                    }

                    print(member)
                }

                let familyId = "14"

                // getFamily
                // familyID가 없을 경우 ( 100 ) : Response status code was unacceptable: 500.
                // familyID가 nil 경우 ( "" ) : Response status code was unacceptable: 400.

                APIClient.shared.getFamily(familyId: familyId, completion: { result, error in
                    guard error.isNone else {
                        print(error!.localizedDescription)
                        return
                    }

                    guard let family = result else {
                        print("is nil")
                        return
                    }

                    print(family)
                })

                // createFamily
                // 있는데 만들려고 하면? Response status code was unacceptable: 400.
//                let familyName = "sangjin family"
//                APIClient.shared.createFamily(familyName: familyName, completion: { result, error in
//                    guard error.isNone else {
//                        print(error!.localizedDescription)
//                        return
//                    }
//
//                    guard let family = result else {
//                        print("is nil")
//                        return
//                    }
//
//                    print(family)
//                })

//                // joinFamily
//                // 다른 가족에 이미 가입되어 있는데 가입하려 하면? Response status code was unacceptable: 400.
//                // 추후에 가족 두개에 가입하는 것도 가능하게 해야하 할 듯????
//                APIClient.shared.joinFamily(familyId: familyId, completion: { result, error in
//                    guard error.isNone else {
//                        print(error!.localizedDescription)
//                        return
//                    }
//
//                    guard let family = result else {
//                        print("is nil")
//                        return
//                    }
//
//                    print(family)
//                })

//                // createMission
//                APIClient.createMission(
//                    missionDetails: NetworkConstants.MissionDetails(
//                        description: "sangjin test",
//                        expireAt: "2021-01-11 22:22",
//                        familyId: familyId,
//                        reward: "money",
//                        title: "Test"
//                    ),
//                    completion: { result, _ in
//
//                    guard let mission = result else {
//                        print("fail")
//                        return
//                    }
//
//                    print(mission)
//                })

//                // getMissions
//                APIClient.shared.getMissions(familyId: familyId, completion: { result, _ in
//                    guard let mission = result else {
//                        print("fail")
//                        return
//                    }
//
//                    print(type(of: mission))
//                    print(mission.first!.createdAt)
//                })
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
