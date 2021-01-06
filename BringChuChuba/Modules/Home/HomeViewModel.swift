//
//  HomeViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

// TODO: Class로 할지 struct로 할지 차이점 다시 공부하고 결정하기
final class HomeViewModel {
    private let coordinator: HomeCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}
