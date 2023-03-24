//
//  SearchViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/24.
//

import UIKit
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
    }
    
    
    // MARK: View

    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
    }
    

    private func initAttribute() {
        navigationItem.title = "검색"
        
        view.backgroundColor = .white
    }

    private func initConstraint() {
        
    }
    
}
