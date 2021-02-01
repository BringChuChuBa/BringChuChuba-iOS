//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import RxCocoa
import RxSwift

final class CreateMissionViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let title: Driver<String>
        let reward: Driver<String>
        let dateSelected: Driver<Date>
        let description: Driver<String>
        let saveTrigger: Driver<Void>
    }

    struct Output {
        let selectedDate: Driver<Date>
        let saveEnabled: Driver<Bool>
        let dismiss: Driver<Void>
    }

    // MARK: Properties
    private let coordinator: HomeCoordinator

    // MARK: Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Transform Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()

        let emptyCheck = Driver.combineLatest(
            input.title,
            input.reward,
            input.description,
            activityIndicator
        ) {
            return !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3
        }

        // TODO: DatePicker tnwjd
        //        let datePicker = input.expireClicked
        //            .flatMap { _ -> Driver<Bool> in
        //                return Driver.just(false)
        //            }

        let selectedDate = input.dateSelected
        // TDDO: 선택한 !date.isFuture 일 경우 Alert
        //            .map { $0.toString }

        let missionDetail = Driver.combineLatest(
            input.title,
            input.reward,
            selectedDate.map { $0.toString },
            input.description
        )

        let dismiss = input.saveTrigger.withLatestFrom(missionDetail)
            .map { title, reward, date, desc in
                return MissionDetails(
                    description: desc,
                    expireAt: date,
                    familyId: GlobalData.shared.familyId,
                    reward: reward,
                    title: title
                )
            }
            .flatMapLatest { detail in
                return Network.shared.request(
                    with: .createMission(missionDetails: detail),
                    for: Mission.self
                )
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
            }
            .mapToVoid()
            .do(onNext: coordinator.popToHome)

        return Output(
            selectedDate: selectedDate,
            saveEnabled: emptyCheck,
            dismiss: dismiss
        )
    }
}
