//
//  GlobalData.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import Foundation

class GlobalData {
    var userToken: String?

    struct StaticInstance {
        static var instance: GlobalData?
    }

    class func sharedInstance() -> GlobalData {
        if StaticInstance.instance == nil {
            StaticInstance.instance = GlobalData()
        }
        return StaticInstance.instance!
    }
}
