//
//  CalendarViewModel.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import RxCocoa
import RxSwift

final class CalendarViewModel {
    private let coordinator: CalendarCoordinator
    private var disposeBag = DisposeBag()

    init(coordinator: CalendarCoordinator) {
        self.coordinator = coordinator
    }
}
