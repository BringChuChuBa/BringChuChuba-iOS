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

        FirebaseApp.configure()
        loginAndCheckToken()
        getMember()

        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }

        // window
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()

        return true
    }

    private func loginAndCheckToken() {
        var finished = false

        Auth.auth().signInAnonymously { result, error in
            guard error.isNone else { return }

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

    private func getMember() {
        var finished = false

        _ = Network.shared.request(with: .getMember, for: Member.self)
            .subscribe { member in
                GlobalData.shared.do {
                    $0.id = member.id
                    $0.point = member.point
                    if let familyId = member.familyId { $0.familyId = familyId }
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
