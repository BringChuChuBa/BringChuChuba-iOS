//
//  MainCoordinator.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

class MainCoordinator: Coordinator {
    /**
     ViewController, ViewModel, Reactor .. 등의 화면단위에 사용하는 클래스의 인스턴스화합니다.
     ViewController 및 ViewModel, Reactor .. 등에 종속성을 주입해야될 인스턴스에 삽입합니다.
     ViewController를 화면에 표시하거나 Push합니다.
     */

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
//        let vc = ViewController.instantiate()
//        navigationController.pushViewController(vc, animated: false)
    }
}
