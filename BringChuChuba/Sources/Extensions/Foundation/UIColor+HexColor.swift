//
//  UIColor+HexString.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/15.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

// extension String {
//    func hexStringToUIColor() -> UIColor {
//        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        if cString.hasPrefix("#") {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if (cString.count) != 6 {
//            return UIColor.gray
//        }
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: cString).scanHexInt64(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
// }
