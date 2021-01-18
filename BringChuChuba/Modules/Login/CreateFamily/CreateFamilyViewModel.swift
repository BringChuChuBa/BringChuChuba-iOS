//
//  CreateFamilyViewModel.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/14.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateFamilyViewModel: ViewModelType {
    private let coordinator: LoginCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    struct Input {
        let familyName: Driver<String>
        let createTrigger: Driver<Void>
        let joinTrigger: Driver<Void>
    }

    struct Output {
        let createEnable: Driver<Bool>
        let create: Driver<Family>
        let toJoin: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let createEnable =  input.familyName
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)

        let create = input.createTrigger.withLatestFrom(input.familyName)
            .flatMapLatest { familyName -> Driver<Family> in
                Network.shared.createFamily(familyName: familyName)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do { family in
                GlobalData.shared.memberFamilyId = family.id ?? ""
                self.coordinator.toHome()
            }

        let toJoin = input.joinTrigger
            .do(onNext: coordinator.toJoin)

        return Output(createEnable: createEnable,
                      create: create,
                      toJoin: toJoin)
    }
}
