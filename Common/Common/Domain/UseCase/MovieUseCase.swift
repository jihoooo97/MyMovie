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
    func getMovieInfo(movieCd: String) -> Single<Movie>
}

open class MovieUseCase: MovieUseCaseProtocol {
    
    fileprivate var provider: Network<MovieAPI>
    
    public init() {
        self.provider = Network<MovieAPI>(plugins: [LoggingPlugin()])
    }
    
    
    public func getDailyBoxOffice(targetDt: String) -> Single<DailyBoxOfficeResult> {
        return provider.requestObject(.dailyBoxOffice(targetDt: targetDt), type: DailyBoxOfficeResult.self)
    }
    
    public func getWeeklyBoxOffice(targetDt: String) -> Single<WeeklyBoxOfficeResult> {
        return provider.requestObject(.weeklyBoxOffice(targetDt: targetDt), type: WeeklyBoxOfficeResult.self)
    }

    public func getMovieInfo(movieCd: String) -> Single<Movie> {
        return provider.requestObject(.movieInfo(movieCd: movieCd), type: Movie.self)
    }
    
}
