//
//  RankingCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit

import RxSwift

final class RankingCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let rankingViewController = RankingViewController(viewModel: .init(coordinator: self))
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(rankingViewController, animated: true)
    }
}
