//
//  UsersCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit
import RxSwift

final class SettingCoordinator: CoordinatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersViewController = SettingViewController(viewModel: .init(coordinator: self))

        navigationController.pushViewController(usersViewController, animated: true)
    }

    func toProfile() {
        let viewModel = ProfileViewModel(coordinator: self)
        let profileVC: ProfileViewController = ProfileViewController(viewModel: viewModel)

        navigationController.pushViewController(profileVC, animated: true)
    }

    func toMyMission() {
        let viewModel = MyMissionViewModel(coordinator: self)
        let myMissionVC: MyMissionPageViewController = MyMissionPageViewController(viewModel: viewModel)

        navigationController.pushViewController(myMissionVC, animated: true)
    }

    func toDoingMission() {
        let viewModel = MyMissionViewModel(coordinator: self)
        let doingMissionVC: MyMissionViewController = MyMissionViewController(viewModel: viewModel)

        navigationController.pushViewController(doingMissionVC, animated: true)
    }

    func showActivity(_ vc: UIActivityViewController) {
        navigationController.present(vc, animated: true)
    }

    func popToHome() {
        navigationController.popViewController(animated: true)
    }
}
