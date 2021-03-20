//
//  LoginCoordinator.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/14.
//

import UIKit

protocol LoginCoordinatorDelegate: class {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: CoordinatorType {
    unowned private let navigationController: UINavigationController

    weak var delegate: LoginCoordinatorDelegate?
    let mainCoordinator: MainCoordinator

    init(
        navigationController: UINavigationController,
        mainCoordinator: MainCoordinator
    ) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    
    func start() {
        let viewController = JoinFamilyViewController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    func toHome() {
//        self.delegate?.didLoggedIn(self)
        mainCoordinator.loginSubject
            .onNext(())
            
    }

    func toCraeteFamily() {
        let viewModel = CreateFamilyViewModel(coordinator: self)
        let viewController = CreateFamilyViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func popToJoinFamily() {
        navigationController.popViewController(animated: true)
    }
}
