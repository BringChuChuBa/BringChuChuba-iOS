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
        let status: String?
        let appear: Driver<Void>
    }
    
    struct Output {
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
        let errorTracker = ErrorTracker()
        
        let missions = input.appear.flatMapLatest { _ -> Driver<[MyMissionCellViewModel]> in
            return Network.shared.requests(
                with: .getMissions(familyId: GlobalData.shared.familyId),
                for: Mission.self
            )
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .map { missions in
                missions.filter { mission -> Bool in
                    if input.status.isSome {
                        return mission.client.id == GlobalData.shared.id
                    }
                    return mission.contractor?.id == GlobalData.shared.id
                }
                .filter { mission -> Bool in
                    if input.status.isSome {
                        return mission.status.rawValue == input.status
                    }
                    return mission.status == .inProgress
                }
                .map { MyMissionCellViewModel(with: $0) }
            }
        }
        
        let error = errorTracker.asDriver()
        
        return Output(
            missions: missions,
            error: error
        )
    }
}
