//
//  UIView+ParentVC.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/04.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}

// UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
