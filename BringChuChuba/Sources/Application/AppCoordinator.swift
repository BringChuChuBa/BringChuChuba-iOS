//
//  MainCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

final class AppCoordinator: CoordinatorType {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.makeKeyAndVisible()
        window.rootViewController = MainViewController(with: .init(window: window))
    }
}
