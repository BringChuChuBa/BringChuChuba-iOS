//
//  UINavigationController+forceUpdateNavBar.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/12.
//

import UIKit

extension UINavigationController {
    func forceUpdateNavBar() {
        DispatchQueue.main.async {
            self.navigationBar.sizeToFit()
        }
      }
}
