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
        let expireClicked: Driver<Void>
        let dateSelected: Driver<Date>
        let description: Driver<String>
        let saveTrigger: Driver<Void>
    }

    struct Output {
        let point: Driver<String>
        let datePickerHidden: Driver<Bool>
        let selectedDate: Driver<String>
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

        let emptyCheck = Driver.combineLatest(input.title,
                                              input.reward,
                                              input.description,
                                              activityIndicator) {
            return !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3
        }

        // TODO: DatePicker tnwjd
        let datePicker = input.expireClicked
            .flatMap { _ -> Driver<Bool> in
                return Driver.just(false)
            }

        let selectedDate = input.dateSelected
            .map { date -> String in
                let dateFormmater: DateFormatter = DateFormatter()
                dateFormmater.dateFormat = Constant.dateFormat
                let dateStr = dateFormmater.string(from: date)
                return dateStr
            }

        let missionDetail = Driver.combineLatest(input.title,
                                                 input.reward,
                                                 selectedDate,
                                                 input.description)

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
                return Network.shared.request(with: .createMission(missionDetails: detail),
                                              for: Mission.self)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .mapToVoid()
            .do(onNext: coordinator.popToHome)

        return Output(
            // TODO: point 필요없을거 같음
            point: Driver.of(GlobalData.shared.point),
            datePickerHidden: datePicker,
            selectedDate: selectedDate,
            saveEnabled: emptyCheck,
            dismiss: dismiss
        )
    }
}
