//
//  CalendarViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class CalendarViewModel: ViewModelType {
    // MARK: - Structs
    struct Input {
    }

    struct Output {
    }

    // MARK: - Properties
    private let coordinator: CalendarCoordinator

    // MARK: - Initializers
    init(coordinator: CalendarCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output()
    }
}
