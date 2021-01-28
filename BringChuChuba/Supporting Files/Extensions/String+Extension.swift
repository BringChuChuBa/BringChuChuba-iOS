//
//  String+Extension.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/28.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
