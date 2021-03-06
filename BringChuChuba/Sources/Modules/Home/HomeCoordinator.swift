//
//  HomeCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit

final class HomeCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = HomeViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    func toCreateMission() {
        let viewModel = CreateMissionViewModel(coordinator: self)
        let viewController = CreateMissionViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func popToHome() {
        navigationController.popViewController(animated: true)
    }
}
