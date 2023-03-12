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
    var boxOfficeTypeRelay: BehaviorRelay<String> { get }
    var dayRangeRelay: BehaviorRelay<String> { get }
    var boxOfficeRelay: BehaviorRelay<[BoxOffice]> { get }
    func updateDailyBoxOffice()
    func updateWeeklyBoxOffice()
}

open class HomeViewModel: HomeViewModelProtocol {

    private let movieUseCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public let boxOfficeTypeRelay = BehaviorRelay<String>(value: "일별 박스오피스")
    public let dayRangeRelay = BehaviorRelay<String>(value: "--------")
    public let boxOfficeRelay = BehaviorRelay<[BoxOffice]>(value: [])
    private let dailyBoxOfficeRelay = BehaviorRelay<BoxOfficeList?>(value: nil)
    private let weeklyBoxOfficeRelay = BehaviorRelay<BoxOfficeList?>(value: nil)
    
    public init(movieUseCase: MovieUseCaseProtocol) {
        self.movieUseCase = movieUseCase
        
        let lastDay = DateParser.getOneDayBeforeDate()
        let lastWeek = DateParser.getOneWeekBeforeDate()
        
        getDailyMovieList(targetDt: lastDay)
        getWeeklyMovieList(targetDt: lastWeek)
    }
    
    private func getDailyMovieList(targetDt: String) {
        movieUseCase.getDailyBoxOffice(targetDt: targetDt)
            .subscribe(on: CurrentThreadScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                // [!] repository
                let result = result.boxOfficeResult
                let boxOfficeType = result.boxofficeType
                let dayRange = result.showRange
                let boxOfficeList = result.dailyBoxOfficeList
                let day = String(dayRange.split{ $0 == "~" }.first!)
                
                let boxOffice = BoxOfficeList(boxOfficeType: boxOfficeType,
                                                  dayRange: day,
                                                  boxOfficeList: boxOfficeList)
                
                self?.dailyBoxOfficeRelay.accept(boxOffice)
                self?.updateDailyBoxOffice()
            }).disposed(by: disposeBag)
    }
    
    private func getWeeklyMovieList(targetDt: String) {
        movieUseCase.getWeeklyBoxOffice(targetDt: targetDt)
            .subscribe(on: CurrentThreadScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                // [!] repository
                let result = result.boxOfficeResult
                let boxOfficeType = result.boxofficeType
                let dayRange = result.showRange
                let boxOfficeList = result.weeklyBoxOfficeList
                
                let boxOffice = BoxOfficeList(boxOfficeType: boxOfficeType,
                                                  dayRange: dayRange,
                                                  boxOfficeList: boxOfficeList)
                
                self?.weeklyBoxOfficeRelay.accept(boxOffice)
            }).disposed(by: disposeBag)
    }
    
    public func updateDailyBoxOffice() {
        guard let boxOffice = dailyBoxOfficeRelay.value else { return }
        boxOfficeTypeRelay.accept(boxOffice.boxOfficeType)
        dayRangeRelay.accept(boxOffice.dayRange)
        boxOfficeRelay.accept(boxOffice.boxOfficeList)
    }
    
    public func updateWeeklyBoxOffice() {
        guard let boxOffice = weeklyBoxOfficeRelay.value else { return }
        boxOfficeTypeRelay.accept(boxOffice.boxOfficeType)
        dayRangeRelay.accept(boxOffice.dayRange)
        boxOfficeRelay.accept(boxOffice.boxOfficeList)
    }
    
}
