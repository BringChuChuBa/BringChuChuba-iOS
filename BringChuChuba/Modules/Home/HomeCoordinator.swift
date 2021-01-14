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
    private var createViewModel: CreateMissionViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController(viewModel: .init(coordinator: self))

        navigationController.pushViewController(homeViewController, animated: true)
    }

    func toCreateMission() {
        let viewModel = CreateMissionViewModel(coordinator: self)
        let createMissionVc: CreateMissionViewController = CreateMissionViewController(viewModel: viewModel)

        createViewModel = viewModel

        navigationController.pushViewController(createMissionVc, animated: true)
    }

    func toDetailMission(_ mission: Mission) {
//        let viewModel =
        // new Coordinator ??
        // VC Create
        // VM init
        // nav.push(VC)
    }

    func toReward() {
        guard let viewModel = createViewModel else {
            return
        }

        let rewardVC: RewardViewController = RewardViewController(viewModel: viewModel)

        navigationController.pushViewController(rewardVC, animated: true)
    }
}
