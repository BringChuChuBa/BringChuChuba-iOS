//
//  SceneCoordinatorType.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }

    func start()
}
