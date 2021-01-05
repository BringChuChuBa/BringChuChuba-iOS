//
//  UIViewController+top.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

extension UIViewController {
    static func top() -> UIViewController {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { fatalError("No view controller present in app?") }
        var result = rootViewController
        while let vc = result.presentedViewController {
            result = vc
        }

        if let tabBar = result as? UITabBarController {
            result = tabBar.selectedViewController ?? tabBar
        }

        if let navigation = result as? UINavigationController {
            result = navigation.topViewController ?? navigation
        }
        return result
    }
}
