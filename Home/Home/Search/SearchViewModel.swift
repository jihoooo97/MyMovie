//
//  SearchViewModel.swift
//  Home
//
//  Created by 유지호 on 2023/03/24.
//

import Common
import RxSwift
import RxRelay

public protocol SearchViewModelProtocol {
    var movieListRelay: BehaviorRelay<[SearchMovieResponse]> { get }
    
    func searchMovie(movieNm: String)
}

open class SearchViewModel: SearchViewModelProtocol {

    private let useCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public let movieListRelay = BehaviorRelay<[SearchMovieResponse]>(value: [])
    
    public init(useCase: MovieUseCaseProtocol) {
        self.useCase = useCase
    }

    
    public func searchMovie(movieNm: String) {
        useCase.searchMovieList(movieNm: movieNm)
            .subscribe(onSuccess: { [weak self] result in
                let result = result.movieListResult
                let movieList = result.movieList
                
                self?.movieListRelay.accept(movieList)
            }).disposed(by: disposeBag)
    }
    
}
