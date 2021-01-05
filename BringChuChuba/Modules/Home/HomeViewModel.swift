//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class HomeViewModel {
    private let coordinator: HomeCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}
