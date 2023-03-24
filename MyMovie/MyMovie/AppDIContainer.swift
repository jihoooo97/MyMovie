//
//  HomeDIContainer.swift
//  MyMovie
//
//  Created by 유지호 on 2023/03/04.
//

import Home
import Common
import UIComponent
import Swinject

enum AppDIContainer {

    static let container: Container = {
        let container = Container()
        
        // MARK: Tabbar
        container.register(TabbarController.self) { r in
            let homeViewController = NavigationController(rootViewController: container.resolve(HomeViewController.self)!)
            homeViewController.tabBarItem.image = UIImage(systemName: "house")
            homeViewController.title = "홈"
            
            let searchViewController = NavigationController(rootViewController: container.resolve(SearchViewController.self)!)
            searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
            searchViewController.title = "검색"

            let myageViewController = NavigationController(rootViewController: UIViewController())
            myageViewController.tabBarItem.image = UIImage(systemName: "person")
            myageViewController.title = "내 정보"
            
            let tabbarController = TabbarController()
            tabbarController.viewControllers = [homeViewController, searchViewController, myageViewController]
            return tabbarController
        }
        
        
        // MARK: BoxOffice
        container.register(HomeViewController.self) { r in
            HomeViewController(viewModel: r.resolve(HomeViewModel.self)!)
        }
        
        container.register(HomeViewModel.self) { r in
            HomeViewModel(movieUseCase: r.resolve(MovieUseCase.self)!)
        }
        
        
        // MARK: Search
        container.register(SearchViewController.self) { r in
            SearchViewController(viewModel: r.resolve(SearchViewModel.self)!)
        }
        
        container.register(SearchViewModel.self) { r in
            SearchViewModel(useCase: r.resolve(MovieUseCase.self)!)
        }
        
        
        // MARK: Mypage
        
        
        
        // MARK: Usecase
        container.register(MovieUseCase.self) { _ in
            MovieUseCase()
        }
        
        
        return container
    }()
    
}
