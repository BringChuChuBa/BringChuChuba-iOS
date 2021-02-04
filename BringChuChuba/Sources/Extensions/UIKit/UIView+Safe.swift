//
//  UIImage+Extension.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/29.
//

import UIKit

import SnapKit

extension UIView {
    var safeArea: ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }

    func roundShadowView() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 4 
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.clipsToBounds = true
    }
}
