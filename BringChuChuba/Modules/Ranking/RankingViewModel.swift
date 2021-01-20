//
//  RankingViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class RankingViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
    }

    struct Output {
    }

    // MARK: - Properties
    private let coordinator: RankingCoordinator

    // MARK: - Initializers
    init(coordinator: RankingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output()
    }
}
