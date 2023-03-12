//
//  HomeDIContainer.swift
//  MyMovie
//
//  Created by 유지호 on 2023/03/04.
//

import Home
import Common
import Swinject

enum AppDIContainer {

    static let container: Container = {
        let container = Container()
        
        // MARK: HOME
        container.register(HomeViewController.self) { r in
            HomeViewController(viewModel: r.resolve(HomeViewModel.self)!)
        }
        
        container.register(HomeViewModel.self) { r in
            HomeViewModel(movieUseCase: r.resolve(MovieUseCase.self)!)
        }
        
        container.register(MovieUseCase.self) { _ in
            MovieUseCase()
        }
        
        return container
    }()
    
}
