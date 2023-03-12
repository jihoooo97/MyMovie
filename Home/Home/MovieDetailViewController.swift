//
//  MoviewDetailViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/12.
//

import UIKit
import UIComponent
import RxSwift
import RxCocoa

open class MovieDetailViewController: UIViewController {

    // MARK: DI
    
    private let viewModel: MovieDetailViewModelProtocol
    
    public init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    var titleLabel = UILabel()
    
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        initAttribute()
        initConstraint()
    }
    
    
    private func bind() {
        viewModel.movieTitleRelay
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
    }

}
