//
//  GlobalData.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

final class GlobalData {
    static let shared = GlobalData()

    var userToken: String?

    private init() {}
}
