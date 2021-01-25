//
//  UIImagePickerController+Rx.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/24.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImagePickerController {

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }

}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
