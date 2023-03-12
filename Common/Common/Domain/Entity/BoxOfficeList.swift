//
//  BoxOfficeList.swift
//  Common
//
//  Created by 유지호 on 2023/03/12.
//

import Foundation

open class BoxOfficeList {
    public var boxOfficeType: String
    public var dayRange: String
    public var boxOfficeList: [BoxOffice]
    
    public init(boxOfficeType: String, dayRange: String, boxOfficeList: [BoxOffice]) {
        self.boxOfficeType = boxOfficeType
        self.dayRange = dayRange
        self.boxOfficeList = boxOfficeList
    }
}
