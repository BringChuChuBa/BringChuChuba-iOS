//
//  Optional+Extension.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import Foundation

extension Optional {
    var isNone: Bool {
        return self == nil
    }

    var isSome: Bool {
        return self != nil
    }
}
