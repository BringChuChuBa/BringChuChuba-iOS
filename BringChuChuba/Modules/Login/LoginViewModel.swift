//
//  RegisterViewModel.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/13.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    private let coordinator: LoginCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    struct Input {
        let familyId: Driver<String>
        let joinTrigger: Driver<Void>
        let createTrigger: Driver<Void>
    }

    struct Output {
        let joinEnabled: Driver<Bool>
        let join: Driver<Void>
        let create: Driver<Void>
    }

    func transform(input: Input) -> Output {
        // familyID, memberName not empty <-> join enable : join button enable
        let joinEnabled =  input.familyId
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)

        // join button tap <-> join trigger >>> login request 로직
        // onNext <-> join success : go to Home
        // onError <-> join failed : textfield reset, alert

        // create button tap <-> create trigger >>> create family request
        let join = input.joinTrigger.withLatestFrom(input.familyId)
            .map { familyId in
                Network.shared.joinFamily(familyId: familyId)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: coordinator.toHome)

        let create = input.createTrigger
            .do(onNext: coordinator.toCraete)

        return Output(joinEnabled: joinEnabled,
                      join: join,
                      create: create)
    }
}
