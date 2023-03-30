//
//  SearchMovieRespone.swift
//  Common
//
//  Created by 유지호 on 2023/03/25.
//

import Foundation

public struct SearchMovieListResult: Codable {
    public var movieListResult: SearchMovieList
}

public struct SearchMovieList: Codable {
    public var totCnt: Int
    public var movieList: [SearchMovieResponse]
}

public struct SearchMovieResponse: Codable {
    public var movieCd: String
    public var movieNm: String
    public var movieNmEn: String
    public var prdtYear: String
    public var openDt: String
    public var prdtStatNm: String
    public var typeNm: String
    public var repNationNm: String
    public var repGenreNm: String
    public var directors: [Director]
}
