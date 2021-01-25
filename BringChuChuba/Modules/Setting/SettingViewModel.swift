//
//  UsersVeiwModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class SettingViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
        let photoTrigger: Driver<Void>
        let myMissionTrigger: Driver<Void>
        let doingMissionTrigger: Driver<Void>
    }

    struct Output {
        let myMission: Driver<Void>
        let doingMission: Driver<Void>
        let profile: Driver<Void>
    }

    // MARK: - Properties
    private let coordinator: SettingCoordinator

    // MARK: - Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        let profile = input.photoTrigger
            .do(onNext: coordinator.toProfile)

        let myMission = input.myMissionTrigger
            .do(onNext: coordinator.toMyMission)

        let doingMission = input.doingMissionTrigger
            .do(onNext: coordinator.toDoingMission)

        return Output(myMission: myMission,
                      doingMission: doingMission,
                      profile: profile)
    }
}
