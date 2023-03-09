//
//  Movie.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation

public class Movie: Decodable {
    var movieCd: String?
    var movieNm: String?
    var movieNmEn: String?
    var prdtYear: String?
    var showTm: String?
    var openDt: String?
    var genres: [Genre]?
    var directors: [Director]?
    var actors: [Actor]?
    var showTypes: [showType]?
    var companys: [Company]?
    var audits: [Audit]?
    var staffs: [Staff]?
}

public class Genre: Decodable {
    var genreNm: String?
}

public class showType: Decodable {
    var showTypeGroupNm: String?
    var showTypeNm: String?
}

public class Company: Decodable {
    var companyCd: String?
    var companyNm: String?
    var companyNmEn: String?
    var companyPartNm: String?
}

public class Audit: Decodable {
    var autditNo: String?
    var watchGradeNm: String?
}
