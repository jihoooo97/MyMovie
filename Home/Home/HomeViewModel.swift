//
//  HomeViewModel.swift
//  Home
//
//  Created by 유지호 on 2023/03/04.
//

import Foundation
import RxSwift
import RxRelay
import Common

public protocol HomeViewModelProtocol {
    var boxOfficeType: BehaviorRelay<String> { get }
    var dayRangeRelay: BehaviorRelay<String> { get }
    var boxOfficeRelay: BehaviorRelay<[BoxOffice]> { get }
    func getDailyMovieList(targetDt: String)
    func getWeeklyMovieList(targetDt: String)
}

open class HomeViewModel: HomeViewModelProtocol {

    private let movieUseCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public let boxOfficeType = BehaviorRelay<String>(value: "일별 박스오피스")
    public let dayRangeRelay = BehaviorRelay<String>(value: "--------")
    public let boxOfficeRelay = BehaviorRelay<[BoxOffice]>(value: [])
    
    public init(movieUseCase: MovieUseCaseProtocol) {
        self.movieUseCase = movieUseCase
    }
    
    public func getDailyMovieList(targetDt: String) {
        movieUseCase.getDailyBoxOffice(targetDt: targetDt)
            .subscribe(on: CurrentThreadScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                guard let result = result.boxOfficeResult,
                      let boxOfficeType = result.boxofficeType,
                      let dayRange = result.showRange,
                      let boxOfficeList = result.dailyBoxOfficeList else { return }
                let day = String(dayRange.split{ $0 == "~" }.first!)
                
                self?.boxOfficeType.accept(boxOfficeType)
                self?.dayRangeRelay.accept(day)
                self?.boxOfficeRelay.accept(boxOfficeList)
            }).disposed(by: disposeBag)
    }
    
    public func getWeeklyMovieList(targetDt: String) {
        movieUseCase.getWeeklyBoxOffice(targetDt: targetDt)
            .subscribe(on: CurrentThreadScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                guard let result = result.boxOfficeResult else { return }
                guard let boxOfficeType = result.boxofficeType,
                      let dayRange = result.showRange,
                      let boxOfficeList = result.weeklyBoxOfficeList else { return }
                
                self?.boxOfficeType.accept(boxOfficeType)
                self?.dayRangeRelay.accept(dayRange)
                self?.boxOfficeRelay.accept(boxOfficeList)
            }).disposed(by: disposeBag)
    }
    
}
