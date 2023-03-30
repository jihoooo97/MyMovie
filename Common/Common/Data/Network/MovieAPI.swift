//
//  MovieAPI.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation
import Moya

public enum MovieAPI {
    case dailyBoxOffice(targetDt: String)
    case weeklyBoxOffice(targetDt: String)
    case searchMovieList(movieNm: String, currentPage: Int)
    case movieInfo(movieCd: String)
    case actorList(peopleNm: String)
    case actorInfo(peopleCd: String)
}


extension MovieAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest")!
    }
    
    public var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/boxoffice/searchDailyBoxOfficeList.json"
        case .weeklyBoxOffice:
            return "/boxoffice/searchWeeklyBoxOfficeList.json"
        case .searchMovieList:
            return "/movie/searchMovieList.json"
        case .movieInfo:
            return "/movie/searchMovieInfo.json"
        case .actorList:
            return "/people/searchPeopleList.json"
        case .actorInfo:
            return "/people/searchPeopleInfo.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .dailyBoxOffice, .weeklyBoxOffice, .searchMovieList,
                .movieInfo, .actorList, .actorInfo:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .dailyBoxOffice(targetDt):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "targetDt": targetDt],
                                      encoding: URLEncoding.queryString)
        case let .weeklyBoxOffice(targetDt):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "targetDt": targetDt,
                                                   "weekGb": "0"],
                                      encoding: URLEncoding.queryString)
        case let .searchMovieList(movieNm, currentPage):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "movieNm": movieNm,
                                                   "curPage": "\(currentPage)",
                                                   "itemPerPage": 20],
                                      encoding: URLEncoding.queryString)
        case let .movieInfo(movieCd):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "movieCd": movieCd],
                                      encoding: URLEncoding.queryString)
        case let .actorList(peopleNm):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "peopleNm": peopleNm],
                                      encoding: URLEncoding.queryString)
        case let .actorInfo(peopleCd):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "peopleCd": peopleCd],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return .none
    }
    
}
