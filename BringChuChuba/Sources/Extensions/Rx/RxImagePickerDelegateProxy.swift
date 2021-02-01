//
//  RxImagePickerDelegateProxy.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/02/01.
//

import UIKit

import RxCocoa
import RxSwift

class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy,
                                  UIImagePickerControllerDelegate {

    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}
