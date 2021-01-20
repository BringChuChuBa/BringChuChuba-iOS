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

    func toMyMission() {
        let viewModel = MyMissionViewModel(coordinator: self)
        let myMissionVC: MyMissionViewController = MyMissionViewController(viewModel: viewModel)

        navigationController.pushViewController(myMissionVC, animated: true)
    }

    func toDoingMission() {
        let viewModel = DoingMissionViewModel(coordinator: self)
        let doingMissionVC: DoingMissionViewController = DoingMissionViewController(viewModel: viewModel)

        navigationController.pushViewController(doingMissionVC, animated: true)
    }
}
