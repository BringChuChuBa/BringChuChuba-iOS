//
//  HomeItemViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import RxCocoa
import RxSwift

final class HomeItemViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let contractTrigger: Driver<Void>
    }

    struct Output {
        let contracted: Driver<Void>
        let contractable: Driver<Bool>
        let error: Driver<Error>
    }

    let mission: Mission

    init (with mission: Mission) {
        self.mission = mission
    }

    // MARK: Methods
    func transform(input: Input) -> Output {
//        let activityIndicator = ActivityIndicator()
//        let fetching = activityIndicator.asDriver()

        let errorTracker = ErrorTracker()

        let contracted = input.contractTrigger
            .flatMapLatest { [weak self] _ -> Driver<Mission> in
                guard let self = self,
                      let missionUid = Int(self.mission.id) else { return .empty() }
                print(self.mission.id)
                return Network.shared.request(
                    with: .contractMission(missionUid: missionUid),
                    for: Mission.self
                )
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            }

        let contractable = contracted
            .filter { $0.client.id != GlobalData.shared.id }
            .filter { $0.status == .todo }
            .filter { $0.expireAt.toDate.isFuture }
            .map { $0.contractor.isNone }
        
        let errors = errorTracker.asDriver()

        return Output(
            contracted: contracted.mapToVoid(),
            contractable: contractable,
            error: errors
        )
    }
}
