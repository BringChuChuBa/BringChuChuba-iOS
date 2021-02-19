//
//  UsersCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit

final class SettingCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SettingViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toProfile() {
        let viewModel = ProfileViewModel(coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toMyMission() {
        let viewModel = MyMissionViewModel(coordinator: self)
        let viewController = MyMissionPageViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toDoingMission() {
        let viewModel = MyMissionViewModel(coordinator: self)
        let viewController = DoingMissionViewController(
            viewModel: viewModel,
            status: .inProgress
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showActivity(_ vc: UIActivityViewController) {
        navigationController.present(vc, animated: true)
    }
    
    func popToHome() {
        navigationController.popViewController(animated: true)
    }
}
