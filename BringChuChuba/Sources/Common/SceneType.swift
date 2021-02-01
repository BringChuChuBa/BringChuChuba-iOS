//
//  LaunchInstructor.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

private let imageStrings = ["house", "flame", "person"]
private let filledImageStrings = imageStrings.map { $0 + ".fill" }

enum SceneType: Int {
    case home
    case ranking
    case setting
    case login

    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: imageStrings[rawValue]),
            selectedImage: UIImage(systemName: filledImageStrings[rawValue])
        )
        let padding: CGFloat = 4
        tabBarItem.imageInsets = UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0)
        return tabBarItem
    }
}
