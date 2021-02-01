//
//  UsersVeiwModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift
import FirebaseDynamicLinks

final class SettingViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let photoTrigger: Driver<Void>
        let myMissionTrigger: Driver<Void>
        let doingMissionTrigger: Driver<Void>
        let inviteFamilyTrigger: Driver<Void>
    }
    
    struct Output {
        let myMission: Driver<Void>
        let doingMission: Driver<Void>
        let profile: Driver<Void>
        let invite: Driver<Void>
    }
    // MARK: Properties
    private let coordinator: SettingCoordinator

    // MARK: Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Methods
    func transform(input: Input) -> Output {
        let profile = input.photoTrigger
            .do(onNext: coordinator.toProfile)
        
        let myMission = input.myMissionTrigger
            .do(onNext: coordinator.toMyMission)
        
        let doingMission = input.doingMissionTrigger
            .do(onNext: coordinator.toDoingMission)

        let invite = input.inviteFamilyTrigger
            .do(onNext: makeDeepLink)

        return Output(myMission: myMission,
                      doingMission: doingMission,
                      profile: profile,
                      invite: invite)
    }
}

extension SettingViewModel {
    func makeDeepLink() {
        // TODO: Constant로 빼기
        var components = URLComponents()
        components.scheme = "https"
        components.host = "bringchuchuba.page.link"
        components.path = "/family"

        let domainURIPrefix = "https://bringchuchuba.page.link"

        let familyQueryItem = URLQueryItem(name: "familyId", value: GlobalData.shared.familyId)
        components.queryItems = [familyQueryItem]

        guard let linkParameter = components.url else { return }

        print("I am sharing \(linkParameter.absoluteString)")
//        link = Uri.parse("https://bring.chuchuba.com/family?fKey=${myInfo.value?.familyId}")
//                    domainUriPrefix = "https://bringchuchuba.page.link"

        guard let shareLink = DynamicLinkComponents.init(link: linkParameter,
                                                         domainURIPrefix: domainURIPrefix)
        else {
            print("Couldn't create FDL components")
            return
        }

        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }

//        shareLink.iOSParameters?.appStoreID = "" // 없음 ㅠ
//        shareLink.iOSParameters?.fallbackURL = "" 앱 스토어 아이디 없을 때
        shareLink.iOSParameters?.minimumAppVersion = "1.0.0"

        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.bring.chuchuba")
        shareLink.androidParameters?.minimumVersion = 100

        // TODO: analytics 추가
        /*
        linkBuilder.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(source: "orkut",
                                                                               medium: "social",
                                                                               campaign: "example-promo")
         */

        // optional, display & populate, recommanded
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "socialMetaTagParameters title"
        shareLink.socialMetaTagParameters?.descriptionText = "socialMetaTagParameters desc"
//        shareLink.socialMetaTagParameters?.imageURL = "socialMetaTagParameters title"

        guard let longURL = shareLink.url else { return }
        print("longURL == \(longURL.absoluteString)")

        shareLink.shorten { [weak self] url, warnings, error in
            if let error = error {
                print("error occured \(error.localizedDescription)")
            }

            if let warnings = warnings {
                for warning in warnings {
                    print("FDL warning: \(warning)")
                }
            }

            guard let url = url else { return }
            print("I have short URL \(url.absoluteString)")
            self?.showShareSheet(url: url)
        }
    }

    // 메시지 등등으로 공유 가능
    func showShareSheet(url: URL) {
        print(url)
        let promoText = "가족 초대 제목인듯 ? \(GlobalData.shared.familyId)"
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)

//        coordinator.showActivity(activityVC)
    }
}
