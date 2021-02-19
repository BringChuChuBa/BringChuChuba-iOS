//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import RxCocoa
import RxSwift

final class MyMissionViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let status: Mission.Status
        let parent: Any
        let appear: Driver<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let missions: Driver<[MyMissionCellViewModel]>
        let error: Driver<Error>
    }
    
    // MARK: Properties
    private let coordinator: SettingCoordinator
    
    // MARK: Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()

        let missions = input.appear.flatMapLatest {
            return Network.shared.requests(
                with: .getMissions(familyId: GlobalData.shared.familyId),
                for: Mission.self
            )
            //                .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        }
        .map { missions in
            missions.filter { $0.status == input.status }
                .filter { mission -> Bool in
                    if input.parent is DoingMissionViewController {
                        return mission.contractor?.id == GlobalData.shared.id
                    }
                    return mission.client.id == GlobalData.shared.id
                }
                .map { MyMissionCellViewModel(with: $0) }
        }

        let error = errorTracker.asDriver()

        return Output(
            fetching: fetching,
            missions: missions,
            error: error
        )
    }
}
