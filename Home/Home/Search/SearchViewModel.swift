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
    func fetchMovie()
}

open class SearchViewModel: SearchViewModelProtocol {

    private let useCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public let searchKeywordRelay = BehaviorRelay<String>(value: "")
    public let movieListRelay = BehaviorRelay<[SearchMovieResponse]>(value: [])
    public var isPaging: Bool = true
    private var currentPage = 1
    private var totalCount = 0
    
    public init(useCase: MovieUseCaseProtocol) {
        self.useCase = useCase
    }

    
    public func searchMovie(movieNm: String) {
        useCase.searchMovieList(movieNm: movieNm, currentPage: 1)
            .subscribe(onSuccess: { [weak self] result in
                let result = result.movieListResult
                let movieList = result.movieList
                
                self?.searchKeywordRelay.accept(movieNm)
                self?.movieListRelay.accept(movieList)
                self?.totalCount = result.totCnt
                self?.currentPage = 1
                self?.isPaging = true
            }).disposed(by: disposeBag)
    }
    
    public func fetchMovie() {
        if isPaging {
            isPaging = false
            
            let movieNm = searchKeywordRelay.value
            var baseList = movieListRelay.value
            
            if baseList.count < totalCount {
                useCase.searchMovieList(movieNm: movieNm, currentPage: currentPage + 1)
                    .subscribe(onSuccess: { [weak self] result in
                        let movieList = result.movieListResult.movieList

                        baseList.append(contentsOf: movieList)
                        self?.movieListRelay.accept(baseList)
                        self?.currentPage += 1
                        self?.isPaging = true
                    }).disposed(by: disposeBag)
            }
        }
    }
    
}
