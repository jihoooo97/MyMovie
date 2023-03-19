//
//  Movie.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation

public struct MovieInfoResult: Codable {
    public var movieInfoResult: MovieInfo
}

public struct MovieInfo: Codable {
    public var movieInfo: Movie
    public var source: String
}

public struct Movie: Codable {
    public var movieCd: String
    public var movieNm: String
    public var movieNmEn: String
    public var movieNmOg: String
    public var showTm: String
    public var prdtYear: String
    public var openDt: String
    public var prdtStatNm: String
    public var typeNm: String
    public var genres: [Genre]
    public var directors: [Director]
    public var actors: [Actor]
    public var showTypes: [showType]
    public var nations: [Nation]
    public var audits: [Audit]
    public var staffs: [Staff]
}

public struct Genre: Codable {
    public var genreNm: String
}

public struct showType: Codable {
    public var showTypeGroupNm: String
    public var showTypeNm: String
}

public struct Nation: Codable {
    public var nationNm: String
}

public struct Audit: Codable {
    public var auditNo: String
    public var watchGradeNm: String
}
