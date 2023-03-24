//
//  MovieDetailViewModel.swift
//  Home
//
//  Created by 유지호 on 2023/03/12.
//

import UIKit
import Common
import RxSwift
import RxRelay

public protocol MovieDetailViewModelProtocol {
    var movieInfoRelay: PublishRelay<Movie> { get }
    var actorListRelay: BehaviorRelay<[Actor]> { get }
    
    func getMovieInfo(movieCode: String)
}

open class MovieDetailViewModel: MovieDetailViewModelProtocol {

    private let useCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public let movieInfoRelay = PublishRelay<Movie>()
    public let actorListRelay = BehaviorRelay<[Actor]>(value: [])
    
    public init(useCase: MovieUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func getMovieInfo(movieCode: String) {
        useCase.getMovieInfo(movieCd: movieCode)
            .subscribe(on: CurrentThreadScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                let movieInfo = result.movieInfoResult.movieInfo
                self?.movieInfoRelay.accept(movieInfo)
                self?.actorListRelay.accept(movieInfo.actors)
            }).disposed(by: disposeBag)
    }

}
