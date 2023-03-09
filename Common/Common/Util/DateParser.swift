//
//  DateParser.swift
//  Common
//
//  Created by 유지호 on 2023/03/06.
//

import Foundation

open class DateParser {

    fileprivate static let day = -86400.0
    
    fileprivate static let dateToStringFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    public init() { }
    
    
    public static func getOneDayBeforeDate() -> String {
        let date = Date().addingTimeInterval(day)
        return dateToStringFormatter.string(from: date)
    }
    
    public static func getOneWeekBeforeDate() -> String {
        let date = Date().addingTimeInterval(7 * day)
        return dateToStringFormatter.string(from: date)
    }
    
}
