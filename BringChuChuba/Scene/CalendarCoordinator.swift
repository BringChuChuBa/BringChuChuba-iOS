//
//  CalendarCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit
import RxSwift

class CalendarCoordinator: Coordinator {
    unowned private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let calendarViewController = CalendarViewController(viewModel: .init(coordinator: self))

        navigationController.pushViewController(calendarViewController, animated: true)
    }
}
