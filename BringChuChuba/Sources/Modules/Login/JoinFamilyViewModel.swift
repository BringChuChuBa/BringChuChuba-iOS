//
//  RegisterViewModel.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/13.
//

import RxCocoa
import RxSwift

final class JoinFamilyViewModel: ViewModelType {
    // MARK: Structs
    struct Input {
        let familyId: Driver<String>
        let joinTrigger: Driver<Void>
        let createTrigger: Driver<Void>
    }

    struct Output {
        let joinEnabled: Driver<Bool>
        let join: Driver<Family>
        let toCreateFamily: Driver<Void>
        let error: Driver<Error>
    }

    // MARK: Properties
    private let coordinator: LoginCoordinator

    // MARK: Initializers
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Methods
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let joinEnabled =  input.familyId
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)

        let join = input.joinTrigger.withLatestFrom(input.familyId)
            .flatMapLatest { familyId -> Driver<Family> in
                Network.shared.request(with: .joinFamily(familyId: familyId), for: Family.self)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do { [unowned self] family in
                GlobalData.shared.familyId = family.id
                self.coordinator.toHome()
            }

        let toCreate = input.createTrigger.do(onNext: coordinator.toCraeteFamily)

        return Output(
            joinEnabled: joinEnabled,
            join: join,
            toCreateFamily: toCreate,
            error: errorTracker.asDriver()
        )
    }
}
