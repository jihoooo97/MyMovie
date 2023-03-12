//
//  BoxOffice.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation

open class DailyBoxOfficeResult: Codable {
    public var boxOfficeResult: DailyBoxOffice?
}

open class DailyBoxOffice: Codable {
    public var boxofficeType: String?
    public var showRange: String?
    public var dailyBoxOfficeList: [BoxOffice]?
}


open class WeeklyBoxOfficeResult: Codable {
    public var boxOfficeResult: WeeklyBoxOffice?
}

open class WeeklyBoxOffice: Codable {
    public var boxofficeType: String?
    public var showRange: String?
    public var yearWeekTime: String?
    public var weeklyBoxOfficeList: [BoxOffice]?
}


open class BoxOffice: Codable {
    public var rnum: String?
    public var rank: String?
    public var rankInten: String?
    public var rankOldAndNew: String?
    public var movieCd: String?
    public var movieNm: String?
    public var openDt: String?
    public var salesAmt: String?
    public var salesShare:String?
    public var salesInten: String?
    public var salesChange: String?
    public var salesAcc: String?
    public var audiCnt: String?
    public var audiInten: String?
    public var audiChange: String?
    public var audiAcc: String?
    public var scrnCnt: String?
    public var showCnt: String?
}
