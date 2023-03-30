//
//  MovieRepository.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation
import RxSwift
import Moya

public protocol MovieUseCaseProtocol {
    func getDailyBoxOffice(targetDt: String) -> Single<DailyBoxOfficeResult>
    func getWeeklyBoxOffice(targetDt: String) -> Single<WeeklyBoxOfficeResult>
    func searchMovieList(movieNm: String, currentPage: Int) -> Single<SearchMovieListResult>
    func getMovieInfo(movieCd: String) -> Single<MovieInfoResult>
}

open class MovieUseCase: MovieUseCaseProtocol {
    
    fileprivate var provider: BaseProvider<MovieAPI>
    
    public init() {
        self.provider = BaseProvider<MovieAPI>(plugins: [LoggingPlugin()])
    }
    
    
    public func getDailyBoxOffice(targetDt: String) -> Single<DailyBoxOfficeResult> {
        return provider.requestObject(.dailyBoxOffice(targetDt: targetDt), type: DailyBoxOfficeResult.self)
    }
    
    public func getWeeklyBoxOffice(targetDt: String) -> Single<WeeklyBoxOfficeResult> {
        return provider.requestObject(.weeklyBoxOffice(targetDt: targetDt), type: WeeklyBoxOfficeResult.self)
    }

    public func searchMovieList(movieNm: String, currentPage: Int) -> Single<SearchMovieListResult> {
        return provider.requestObject(.searchMovieList(
            movieNm: movieNm, currentPage: currentPage
        ), type: SearchMovieListResult.self)
    }
    
    public func getMovieInfo(movieCd: String) -> Single<MovieInfoResult> {
        return provider.requestObject(.movieInfo(movieCd: movieCd), type: MovieInfoResult.self)
    }
    
}
