//
//  CreateMissionViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import RxSwift
import RxCocoa
import DatePickerDialog

final class CreateMissionViewModel: ViewModelType {
    // MARK: - Properties
    private let coordinator: HomeCoordinator
    private let disposeBag: DisposeBag = DisposeBag()

    private var tempDate: String?

    // MARK: - Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Transform Methods
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()

        let emptyCheck = Driver.combineLatest(
            input.title,
            input.expireDate,
            activityIndicator) {
            return !$0.isEmpty && !$2
        }

        let toReward = input.reward
            .do(onNext: coordinator.toReward)

        let test = input.expireDate
            .do(onNext: datePickerTapped)

        guard let date = tempDate else {
            return Output(
                point: Driver.just(GlobalData.shared.memberPoint),
                toReward: toReward,
                test: test,
                showPicker: Driver.just("expireDate"),
                saveEnabled: emptyCheck
            )
        }

        let dateStr = Driver.just(date)

        return Output(
            point: Driver.just(GlobalData.shared.memberPoint),
            toReward: toReward,
            test: test,
            showPicker: dateStr,
            saveEnabled: emptyCheck
        )
    }

    func dateTransform() {

    }

    func rewardTransform() {

    }

    private func datePickerTapped() {
        DatePickerDialog().show(
            "DatePicker",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            datePickerMode: .dateAndTime
        ) { [weak self] date in
            if let dateStr = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"

                self?.tempDate = formatter.string(from: dateStr)
            }
        }
    }
}

extension CreateMissionViewModel {
    struct Input {
        let appear: Driver<Void>
        let title: Driver<String>
        let description: Driver<String>
        let reward: Driver<Void>
        let expireDate: Driver<Void>
        let saveTrigger: Driver<Void>
    }

    struct Output {
        let point: Driver<String>
        let toReward: Driver<Void>
        let test: Driver<Void>
        let showPicker: Driver<String>
        let saveEnabled: Driver<Bool>
    }
}
