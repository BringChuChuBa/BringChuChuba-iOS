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
        let create: Driver<Void>
        let dismiss: Driver<Void>
    }

    func transform(input: Input) -> Output {
        // familyID, memberName not empty <-> join enable : join button enable
        let createEnable =  input.familyName
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)

        // join button tap <-> join trigger >>> login request 로직
        // onNext <-> join success : go to Home
        // onError <-> join failed : textfield reset, alert

        // create button tap <-> create trigger >>> create family request
        let create = input.createTrigger.withLatestFrom(input.familyName)
            .map { familyName in
                Network.shared.createFamily(familyName: familyName)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: coordinator.toHome)


        let dismiss = input.joinTrigger
            .do(onNext: coordinator.toJoin)

        return Output(createEnable: createEnable,
                      create: create,
                      dismiss: dismiss)
    }
}

