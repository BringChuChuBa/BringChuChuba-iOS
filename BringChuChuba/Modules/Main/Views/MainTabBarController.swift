//
//  MainTabBarController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func setUpViewControllers() {

    }
}

// MARK: - Set UI
extension MainTabBarController {
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    }
}
