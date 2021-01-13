//
//  MainCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit
import RxSwift
import RxCocoa

final class MainCoordinator: Coordinator {
    // Singleton 객체로 선언하는게 맞는가?
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let homeNavigationController = getNavigationController(from: .home)
        let calendarNavigationController = getNavigationController(from: .calendar)
        let rankingNavigationController = getNavigationController(from: .ranking)
        let usersNavigationController = getNavigationController(from: .users)
        // 가족 확인 VC

        coordinatorInit(from: .home, with: homeNavigationController)
        coordinatorInit(from: .calendar, with: calendarNavigationController)
        coordinatorInit(from: .ranking, with: rankingNavigationController)
        coordinatorInit(from: .users, with: usersNavigationController)
        // 가족 코디네이터

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController,
                                            calendarNavigationController,
                                            rankingNavigationController,
                                            usersNavigationController]

        // 코디네이터가 로직을 처리하면 안될 거 같긴 한데
        // if 가족 o -> root = tabBar
        // 없으면 가족 coordinator 이동시켜서 로직처리

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    // MARK: - Private methods
    private func getNavigationController(from type: SceneType) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = type.tabBarItem
        return navigationController
    }

    private func coordinatorInit(from type: SceneType, with navigationController: UINavigationController) {
        let coordinator: Coordinator

        switch type {
        case .home:
            coordinator = HomeCoordinator(navigationController: navigationController)
        case .calendar:
            coordinator = CalendarCoordinator(navigationController: navigationController)
        case .ranking:
            coordinator = RankingCoordinator(navigationController: navigationController)
        case .users:
            coordinator = UsersCoordinator(navigationController: navigationController)
        }

        coordinator.start()
    }
}