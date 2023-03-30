//
//  SearchViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/24.
//

import UIKit
import Common
import UIComponent
import RxSwift
import RxCocoa

open class SearchViewController: UIViewController {

    // MARK: DI
    private let viewModel: SearchViewModelProtocol
    
    public init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Constraint
    private struct Constraint {
        static let defaultLeftRight = 8.0
        static let defaultTopBottom = 8.0
        static let searchBarHeight = 56.0
    }
    
    
    // MARK: View
    var searchBar = UISearchBar()
    var searchResultTableView = SearchMovieTableView()
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
        bind()
    }
    

    private func bind() {
        searchBar.rx.searchButtonClicked
            .withUnretained(self).map { $0.0 }
            .bind(onNext: { vc in
                vc.searchResultTableView.setContentOffset(.zero, animated: false)
                vc.viewModel.searchMovie(movieNm: vc.searchBar.text ?? "")
                vc.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        viewModel.movieListRelay
            .bind(to: searchResultTableView.rx.items(
                cellIdentifier: SearchMovieCell.cellID,
                cellType: SearchMovieCell.self
            )) { index, data, cell in
                cell.bind(movie: data)
            }.disposed(by: disposeBag)
        
        searchResultTableView.rx.didScroll
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .map { ($0, $0.searchResultTableView.contentOffset.y) }
            .bind(onNext: { vc, offset in
                let contentHeight = vc.searchResultTableView.contentSize.height
                let pagenationY = vc.searchResultTableView.frame.height

                if offset > contentHeight - pagenationY - 100  {
                    vc.viewModel.fetchMovie()
                }
            }).disposed(by: disposeBag)
        
        searchResultTableView.rx.modelSelected(SearchMovieResponse.self)
            .withUnretained(self).map {$0 }
            .bind(onNext: { vc, movie in
                let viewModel = MovieDetailViewModel(useCase: MovieUseCase())
                viewModel.getMovieInfo(movieCode: movie.movieCd)
                let movieDetailView = MovieDetailViewController(viewModel: viewModel)
                vc.navigationController?.pushViewController(movieDetailView, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        navigationItem.title = "검색"
        
        view.backgroundColor = .white
        
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.backgroundImage = UIImage()
            searchBar.barTintColor = .white
            searchBar.searchTextField.layer.borderWidth = 1
            searchBar.searchTextField.layer.borderColor = UIColor.systemBlue.cgColor
            searchBar.searchTextField.layer.cornerRadius = 12
            searchBar.searchTextField.backgroundColor = .white
            searchBar.searchTextField.leftView?.tintColor = .systemBlue
            searchBar.placeholder = "영화명"
            searchBar.searchTextField.textColor = .black
            searchBar.delegate = self
            return searchBar
        }()
        
        searchResultTableView.keyboardDismissMode = .onDrag
        searchResultTableView.delegate = self
    }

    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [searchBar, searchResultTableView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeArea)
            $0.height.equalTo(56)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(searchBar.snp.bottom).offset(Constraint.defaultTopBottom)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate { }

extension SearchViewController: UISearchBarDelegate {
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
}
