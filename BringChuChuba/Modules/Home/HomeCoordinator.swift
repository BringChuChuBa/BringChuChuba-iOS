//
//  HomeCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit
import RxSwift

final class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController(viewModel: .init(coordinator: self))

        navigationController.pushViewController(homeViewController, animated: true)
    }

    func toCreateMission() {
        // VC Create
        // VM init
        // nav.present(VC)
    }

    func toDetailMission(_ mission: Mission) {
        // new Coordinator ??
        // VC Create
        // VM init
        // nav.push(VC)
    }
}
