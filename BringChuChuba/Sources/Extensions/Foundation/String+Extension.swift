//
//  String+Extension.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/28.
//

import Foundation

extension String {
    public var localized: String {
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: Bundle.main,
            value: "",
            comment: ""
        )
    }

    public var toDate: Date {
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = Constants.dateFormat
            $0.locale = Locale.current
            $0.timeZone = TimeZone.autoupdatingCurrent
        }
        return dateFormatter.date(from: self)!
    }
}
