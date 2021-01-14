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
//    private var check: Bool = false

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

//        let clicked = input.expireClicked
//            .flatMap { _ -> Driver<Bool> in
//                return Driver.
//            }

        let datePicker = Driver.merge(
            input.expireClicked,
            input.expireResigned
        )

        return Output(
            point: Driver.just(GlobalData.shared.memberPoint),
            saveEnabled: emptyCheck
//            datePickerHidden: datePicker
        )
    }

    func dateTransform() {

    }

    func rewardTransform() {

    }
}

extension CreateMissionViewModel {
    struct Input {
        let title: Driver<String>
        let expireClicked: Driver<Void>
        let expireResigned: Driver<Void>
        let expireDate: Driver<String>
        let description: Driver<String>
        let saveTrigger: Driver<Void>
    }

    struct Output {
        let point: Driver<String>
        let saveEnabled: Driver<Bool>
//        let datePickerHidden: Driver<Bool>
    }
}
