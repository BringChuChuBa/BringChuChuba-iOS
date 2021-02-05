//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class HomeViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let trigger: Driver<Void>
        let segmentSelected: Driver<Mission.Status>
        let createMissionTrigger: Driver<Void>
//        let contractTrigger: Driver<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let items: Driver<[HomeItemViewModel]>
        let createMission: Driver<Void>
        let error: Driver<Error>
    }
    
    // MARK: Properties
    private let coordinator: HomeCoordinator
    
    // MARK: Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let missions = input.trigger
            .flatMapLatest { _ -> Driver<[Mission]> in
                Network.shared.requests(
                    with: .getMissions(familyId: GlobalData.shared.familyId),
                    for: Mission.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            }

        let items = Driver.combineLatest(missions, input.segmentSelected)
            .compactMap { missions, segmentSelected -> [HomeItemViewModel] in
                missions.filter { $0.status == segmentSelected }
                    .compactMap { HomeItemViewModel(with: $0) }
            }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        let createMission = input.createMissionTrigger
            .do(onNext: coordinator.toCreateMission)
        
        return Output(
            fetching: fetching,
            items: items,
            createMission: createMission,
            error: errors
        )
    }
}
