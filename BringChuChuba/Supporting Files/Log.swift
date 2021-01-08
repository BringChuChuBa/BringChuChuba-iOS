//
//  Log.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import Foundation
import os.log

final class Log {
    static func error(_ message: String) {
        os_log("%@", log: .default, type: .error, message)
    }

    static func debug(_ message: String) {
        os_log("%@", log: .default, type: .debug, message)
    }
}
