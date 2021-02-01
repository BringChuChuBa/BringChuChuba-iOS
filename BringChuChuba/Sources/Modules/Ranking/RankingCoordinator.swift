//
//  RankingCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit

final class RankingCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = RankingViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
}
