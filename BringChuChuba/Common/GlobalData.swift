//
//  GlobalData.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

class GlobalData {
    static let shared = GlobalData()
    private init() {}

    var userToken: String = ""
    var currentMember: Member!
    var memberId: String = ""
    var memberFamilyId: String = ""
    var memberPoint: String = ""
}
