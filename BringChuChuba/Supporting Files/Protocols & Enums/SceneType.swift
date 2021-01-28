//
//  LaunchInstructor.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

enum SceneType: String {
    case home
    case ranking
    case setting
    case login

    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: rawValue), selectedImage: nil)
        let padding: CGFloat = 4
        tabBarItem.imageInsets = UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0)
        return tabBarItem
    }
}
