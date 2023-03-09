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
    
    fileprivate var provider = MoyaProvider<MovieAPI>()
    
    public init() {
        let netwokrLoggerPlugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(entry: { (identifier, message, targetType) -> String in
            if identifier != "Response" {
                return "[\(identifier)] \(message)"
            }
            return "Response"
        }, requestData: { data in
            return data.prettyPrintedJSONString as String? ?? ""
        }, responseData: { data in
            return data.prettyPrintedJSONString as String? ?? ""
        }), output: { target, items in
            print("------------------------------------------------------------")
            items.forEach { if $0 != "Response" { print($0) } }
            print("------------------------------------------------------------")
        }, logOptions: [.verbose]))
    
        let networkActivityPlugin = NetworkActivityPlugin { change, target in
            switch change {
            case .began:
                break
            case .ended:
                break
            }
        }
        
        let configuration = URLSessionConfiguration.default
        let session = Session(configuration: configuration)
        
        provider = MoyaProvider(session: session, plugins: [netwokrLoggerPlugin])
    }
    
    
    public func getDailyBoxOffice(targetDt: String) -> Single<DailyBoxOfficeResult> {
        return provider.rx.request(.dailyBoxOffice(targetDt: targetDt))
            .map(DailyBoxOfficeResult.self)
    }
    
    public func getWeeklyBoxOffice(targetDt: String) -> Single<WeeklyBoxOfficeResult> {
        return provider.rx.request(.weeklyBoxOffice(targetDt: targetDt))
            .map(WeeklyBoxOfficeResult.self)
    }

    public func getMovieInfo(movieCd: String) -> Single<Movie> {
        return provider.rx.request(.movieInfo(movieCd: movieCd))
            .map(Movie.self)
    }
    
}
