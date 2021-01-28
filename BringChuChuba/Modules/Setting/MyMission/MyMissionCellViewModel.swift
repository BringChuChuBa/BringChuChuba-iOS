//
//  MyMissionItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import RxCocoa
import RxSwift

final class MyMissionCellViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let deleteTrigger: Driver<Void>
        let completeTrigger: Driver<Void>
    }

    struct Output {
        let deleted: Driver<Void>
        let completed: Driver<Void>
    }

    // MARK: Properties
    let title: String
    let description: String
    let status: String
    let mission: Mission

    // MARK: Initializers
    init (with mission: Mission) {
        self.mission = mission
        self.title = mission.title
        self.description = mission.description ?? "No description"
        self.status = mission.status.rawValue
    }

    // MARK: Methods
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let deleted = input.deleteTrigger
            .flatMapLatest { [weak self] _ -> Driver<Void> in
                guard let self = self else { return Driver.empty() }
                guard let missionUid = Int(self.mission.id) else { return Driver.empty() }

                return Network.shared.request(with: .deleteMission(missionUid: missionUid), for: Result.self)
                    .trackError(errorTracker)
                    .map { _ in }
                    .asDriverOnErrorJustComplete()
            }

        let completed = input.completeTrigger
            .flatMapLatest { [weak self] _ -> Driver<Void> in
                guard let self = self else { return Driver.empty() }
                guard let missionUid = Int(self.mission.id) else { return Driver.empty() }

                return Network.shared.request(with: .completeMission(missionUid: missionUid), for: Mission.self)
                    .trackError(errorTracker)
                    .map { _ in }
                    .asDriverOnErrorJustComplete()
            }

        return Output(deleted: deleted,
                      completed: completed)
    }
}
