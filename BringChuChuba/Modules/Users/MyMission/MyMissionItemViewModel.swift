//
//  MyMissionItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import RxSwift
import RxCocoa

final class MyMissionItemViewModel: ViewModelType {
    // MARK: - Structs
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
    let reward: String
    let mission: Mission
    private let viewModel: MyMissionViewModel

    // MARK: Initializers
    init (with mission: Mission, parent: MyMissionViewModel) {
        self.mission = mission
        self.title = mission.title
        self.description = mission.description ?? "미션 설명"
        self.reward = mission.status
        self.viewModel = parent
    }

    func transfer(input: Input) {
        viewModel.cellTransform(input: input)
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let deleted = input.deleteTrigger
            .mapToVoid()

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
