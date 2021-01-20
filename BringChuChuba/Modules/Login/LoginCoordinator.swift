//
//  LoginCoordinator.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/14.
//

import Foundation
import RxSwift

protocol LoginCoordinatorDelegate: class {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController
    weak var delegate: LoginCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let loginViewController = LoginViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func toHome() {
        self.delegate?.didLoggedIn(self)
    }

    func toCraete() {
        let viewModel = CreateFamilyViewModel(coordinator: self)
        let viewController = CreateFamilyViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func toJoin() {
        navigationController.popViewController(animated: true)
    }
}
