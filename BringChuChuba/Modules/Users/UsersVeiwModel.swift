//
//  UsersVeiwModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class UsersViewModel {
    private let coordinator: UsersCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: UsersCoordinator) {
        self.coordinator = coordinator
    }
}
