//
//  HomeCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit
import RxSwift

final class HomeCoordinator: CoordinatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewController = HomeViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    func toCreateMission() {
        let viewModel = CreateMissionViewModel(coordinator: self)
        let viewController = CreateMissionViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func toDetailMission(_ mission: Mission) {
        let viewModel = DetailMissionViewModel(mission: mission, coordinator: self)
        let viewController = DetailMissionViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func popToHome() {
        navigationController.popViewController(animated: true)
    }
}
