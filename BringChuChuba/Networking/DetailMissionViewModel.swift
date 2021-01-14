//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import RxSwift
import RxCocoa

final class DetailMissionViewModel: ViewModelType {
    // MARK: - Properties
    private let mission: Mission
    private let coordinator: HomeCoordinator
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initializers
    init(mission: Mission, coordinator: HomeCoordinator) {
        self.mission = mission
        self.coordinator = coordinator
    }

    // MARK: - Transform Methods
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

//        let activityIndicator = ActivityIndicator()
//        let emptyCheck = Driver.combineLatest(
//            input.title,
//            input.expireDate,
//            activityIndicator) {
//            return !$0.isEmpty && !$2
//        }
//
//        guard let date = tempDate else {
//            return Output(
//                point: Driver.just(GlobalData.shared.memberPoint),
//                toReward: toReward,
//                test: test,
//                showPicker: Driver.just("expireDate"),
//                saveEnabled: emptyCheck
//            )
//        }
//
//        let dateStr = Driver.just(date)
//
//        return Output(
//            point: Driver.just(GlobalData.shared.memberPoint),
//            toReward: toReward,
//            test: test,
//            showPicker: dateStr,
//            saveEnabled: emptyCheck
//        )
        return Output()
    }
}

extension DetailMissionViewModel {
    struct Input {
//        let appear: Driver<Void>
//        let title: Driver<String>
//        let description: Driver<String>
//        let reward: Driver<Void>
//        let expireDate: Driver<Void>
//        let saveTrigger: Driver<Void>
    }

    struct Output {
//        let point: Driver<String>
//        let toReward: Driver<Void>
//        let test: Driver<Void>
//        let showPicker: Driver<String>
//        let saveEnabled: Driver<Bool>
    }
}
