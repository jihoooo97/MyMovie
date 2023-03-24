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
    
}

open class SearchViewModel: SearchViewModelProtocol {

    private let useCase: MovieUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public init(useCase: MovieUseCaseProtocol) {
        self.useCase = useCase
    }
    
}
