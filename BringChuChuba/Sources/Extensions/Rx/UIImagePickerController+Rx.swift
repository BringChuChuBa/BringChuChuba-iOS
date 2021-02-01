//
//  UIImagePickerController+Rx.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIImagePickerController {

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return delegate
            .methodInvoked(
                #selector(
                    UIImagePickerControllerDelegate
                    .imagePickerController(_:didFinishPickingMediaWithInfo:)
                    )
            )
            .map { return try castOrThrow(
                Dictionary<UIImagePickerController.InfoKey, AnyObject>.self,
                $0[1]
            )}
    }
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(
                #selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:))
            )
            .map {_ in () }
    }

}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
