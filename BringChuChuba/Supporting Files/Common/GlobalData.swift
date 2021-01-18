//
//  GlobalData.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

final class GlobalData {
    static let shared = GlobalData()
    private init() {}

    var userToken: String = ""
    var currentMember: Member!
    var id: String = ""
    var familyId: String = ""
    var point: String = ""
    var nickname: String = ""
}
