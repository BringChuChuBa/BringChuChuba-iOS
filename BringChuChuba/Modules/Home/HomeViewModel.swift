//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
        let trigger: Driver<Void>
        let createMissionTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let fetching: Driver<Bool>
        let missions: Driver<[HomeItemViewModel]>
        let createMission: Driver<Void>
        let selectedMission: Driver<Mission>
        let error: Driver<Error>
    }

    // MARK: - Properties
    private let coordinator: HomeCoordinator

    // MARK: - Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let missions = input.trigger
            .flatMapLatest { _ -> Driver<[HomeItemViewModel]> in
                return Network.shared.requests(with: .getMissions(familyId: GlobalData.shared.familyId),
                                               for: Mission.self)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { missions in
                        missions.map { mission in
                            HomeItemViewModel(with: mission)
                        }
                    }
            }
        // TODO: mission status 별로 그룹핑하는 groupBy 연산 수행

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let selectedMission = input.selection
            .withLatestFrom(missions) { (indexPath, missions) -> Mission in
                return missions[indexPath.row].mission
            }
            .do(onNext: coordinator.toDetailMission)

        let createMission = input.createMissionTrigger
            .do(onNext: coordinator.toCreateMission)

        return Output(fetching: fetching,
                      missions: missions,
                      createMission: createMission,
                      selectedMission: selectedMission,
                      error: errors)
    }
}
