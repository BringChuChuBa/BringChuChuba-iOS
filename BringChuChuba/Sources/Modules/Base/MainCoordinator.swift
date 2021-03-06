//
//  BaseCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/13.
//

import UIKit

import Then
import RxSwift

// TODO: 1줄을 짧게 쓰기 위해 2줄을 추가하는게 맞는가?
final class MainCoordinator: CoordinatorType, Then {
    private let window: UIWindow

    let loginSubject: PublishSubject<Void> = .init()
    var disposeBag: DisposeBag = .init()

    init(window: UIWindow) {
        self.window = window

        _ = loginSubject
            .subscribe(onNext: { [weak self] in
                self?.showMainTab()
            })
    }

    func start() {
    }

    func showLogin() {
        let navigationController = UINavigationController()
        let coordinator = LoginCoordinator(navigationController: navigationController,
                                           mainCoordinator: self)
        coordinator.delegate = self
        coordinator.start()
//        coordinatorInit(from: .login, with: navigationController)
        window.rootViewController = navigationController
    }

    func showMainTab() {
        let homeNavigationController = getNavigationController(from: .home)
        let rankingNavigationController = getNavigationController(from: .ranking)
        let usersNavigationController = getNavigationController(from: .setting)
        // 가족 확인 VC

        coordinatorInit(from: .home, with: homeNavigationController)
        coordinatorInit(from: .ranking, with: rankingNavigationController)
        coordinatorInit(from: .setting, with: usersNavigationController)
        // 가족 코디네이터

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController,
                                            rankingNavigationController,
                                            usersNavigationController]
        // 코디네이터가 로직을 처리하면 안될 거 같긴 한데
        // if 가족 o -> root = tabBar
        // 없으면 가족 coordinator 이동시켜서 로직처리

        loginSubject
            .disposed(by: disposeBag)

        window.rootViewController = tabBarController
    }

    // MARK: Private methods
    private func getNavigationController(from type: SceneType) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true

        navigationController.tabBarItem = type.tabBarItem

        return navigationController
    }

    private func coordinatorInit(from type: SceneType, with navigationController: UINavigationController) {
        let coordinator: CoordinatorType

        switch type {
        case .home:
            coordinator = HomeCoordinator(navigationController: navigationController)
        case .ranking:
            coordinator = RankingCoordinator(navigationController: navigationController)
        case .setting:
            coordinator = SettingCoordinator(navigationController: navigationController)
        case .login:
            coordinator = LoginCoordinator(navigationController: navigationController,
                                           mainCoordinator: self)
        }

        coordinator.start()
    }
}

extension MainCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        showMainTab()
    }
}
