//
//  Date+Extension.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/31.
//

import Foundation

enum DateRoundingType {
    case round
    case ceil
    case floor
}

extension Date {
    public var currentTime: String {
        return self.description(with: .current)
    }

    public var toString: String {
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = Constants.dateFormat
            $0.locale = Locale.current
            $0.timeZone = TimeZone.autoupdatingCurrent
        }
        return dateFormatter.string(from: self)
    }

    public var isFuture: Bool {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        return now - time < 0
    }

    public var isDateInThisMonth: Bool {
        return Calendar.current.isDate(Date(), equalTo: self, toGranularity: .month)
    }

    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }

    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }

}
