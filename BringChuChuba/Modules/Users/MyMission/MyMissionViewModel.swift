//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import RxSwift
import RxCocoa

final class MyMissionViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
        let appear: Driver<Void>
    }

    struct Output {
        let missions: Driver<[MyMissionItemViewModel]>
    }

    // MARK: - Properties
    private let coordinator: SettingCoordinator

    // MARK: - Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Transform Methods
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let missions = input.appear
            .flatMapLatest { _ -> Driver<[MyMissionItemViewModel]> in
                return Network.shared.requests(with: .getMissions(familyId: GlobalData.shared.familyId),
                                               for: Mission.self)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { missions in
                        missions.filter { mission -> Bool in
                            return mission.client.id == GlobalData.shared.id
                        }
                        .map { mission in
                            MyMissionItemViewModel(with: mission,
                                                   parent: self)
                        }
                    }
            }

        return Output(missions: missions)
    }

    func cellTransform(input: MyMissionItemViewModel.Input) {
    }
}
