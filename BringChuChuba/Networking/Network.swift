//
//  Network.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/13.
//

import Moya
import RxSwift

final class Network {
    static let shared = Network()
    private init() {}

    private let provider = MoyaProvider<Router>(plugins: [NetworkLoggerPlugin()])
    private let disposeBag = DisposeBag()

    func getMember() -> Single<Member> {
        return provider.rx.request(.getMember)
            .debug()
            .filterSuccessfulStatusCodes() // validate 200 - 299
            .map(Member.self) // decode
            .catchError { error in
                throw error
            }
    }

    func getFamily(familyUid: Int) -> Single<Family> {
        return provider.rx.request(.getFamily(familyUid: familyUid))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(Family.self)
    }

    func createFamily(familyName: String) -> Single<Family> {
        return provider.rx.request(.createFamily(familyName: familyName))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(Family.self)
    }

    func joinFamily(familyId: String) -> Single<Family> {
        return provider.rx.request(.joinFamily(familyId: familyId))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(Family.self)
    }

    func getMissions(familyId: String) -> Single<[Mission]> {
        return provider.rx.request(.getMissions(familyId: familyId))
            .debug()
            .filterSuccessfulStatusCodes()
            .map([Mission].self)
    }

    func createMission(missionDetails: MissionDetails) -> Single<MissionDetails> {
        return provider.rx.request(.createMission(missionDetails: missionDetails))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(MissionDetails.self)
    }

    func contractMission(missionUid: Int) -> Single<Mission> {
        return provider.rx.request(.contractMission(missionUid: missionUid))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(Mission.self)
    }

    func completeMission(missionUid: Int) -> Single<Mission> {
        return provider.rx.request(.completeMission(missionUid: missionUid))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(Mission.self)
    }
}

private enum Error {
    case Unknown
}
