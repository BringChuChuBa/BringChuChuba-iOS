//
//  RankingViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class RankingViewModel {
    private let coordinator: RankingCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: RankingCoordinator) {
        self.coordinator = coordinator
    }
}
