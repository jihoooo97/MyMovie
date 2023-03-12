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
        case .dailyBoxOffice, .weeklyBoxOffice,
                .movieInfo, .actorList, .actorInfo:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .dailyBoxOffice(let targetDt):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "targetDt": targetDt,
                                                   "repNationCd": "K"],
                                      encoding: URLEncoding.queryString)
        case .weeklyBoxOffice(let targetDt):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "targetDt": targetDt,
                                                   "repNationCd": "K",
                                                   "weekGb": "0"],
                                      encoding: URLEncoding.queryString)
        case .movieInfo(let movieCd):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "movieCd": movieCd],
                                      encoding: URLEncoding.queryString)
        case .actorList(let peopleNm):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "peopleNm": peopleNm],
                                      encoding: URLEncoding.queryString)
        case .actorInfo(let peopleCd):
            return .requestParameters(parameters: ["key": MyKeys.movie,
                                                   "peopleCd": peopleCd],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return .none
    }
    
}
