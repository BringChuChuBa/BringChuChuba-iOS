//
//  UsersCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/04.
//

import UIKit
import RxSwift

final class UsersCoordinator: Coordinator {
    unowned private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersViewController = UsersViewController(viewModel: .init(coordinator: self))

        navigationController.pushViewController(usersViewController, animated: true)
    }
}
