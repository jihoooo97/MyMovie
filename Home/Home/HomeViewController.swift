//
//  MainViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/04.
//

import UIKit
import Common
import UIComponent
import RxSwift
import RxCocoa
import SnapKit

open class HomeViewController: UIViewController {

    // MARK: DI
    
    private let viewModel: HomeViewModelProtocol
    
    public init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View
    
    var headerView = UIView()
    var dayRangeLabel = UILabel()
    var dailyBoxOfficeButton = UIButton()
    var weeklyBoxOfficeButton = UIButton()
    var indicatorView = UIView()
    var boxOfficeTableView = BoxOfficeTableView()
    
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initLayout()
        bind()
    }
    
    private func bind() {
        viewModel.dayRangeRelay
            .bind(to: dayRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.boxOfficeRelay
            .bind(to: boxOfficeTableView.rx.items(cellIdentifier: BoxOfficeCell.cellID,
                                                  cellType: BoxOfficeCell.self)
            ) { (index, item, cell) in
                cell.bind(boxOffice: item)
            }.disposed(by: disposeBag)
        
        viewModel.boxOfficeTypeRelay
            .bind(onNext: { [weak self] type in
                self?.dailyBoxOfficeButton.isSelected = type.first! == "일"
                self?.weeklyBoxOfficeButton.isSelected = type.first! == "주"
            }).disposed(by: disposeBag)
        
        dailyBoxOfficeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.updateDailyBoxOffice()
            }).disposed(by: disposeBag)

        weeklyBoxOfficeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.updateWeeklyBoxOffice()
            }).disposed(by: disposeBag)
        
        boxOfficeTableView.rx.itemSelected
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { [weak self] in
                (self?.viewModel.boxOfficeRelay.value[$0.row])!
            }
            .bind(onNext: { [weak self] item in
                // 각 모듈마다 Container
                let viewModel = MovieDetailViewModel(useCase: MovieUseCase())
                viewModel.getMovieInfo(movieCode: item.movieCd)
                let movieDetailView = MovieDetailViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(movieDetailView, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
        
        headerView.backgroundColor = .white
        
        dayRangeLabel.textColor = .lightGray
        
        dailyBoxOfficeButton = {
            let button = UIButton()
            button.setTitle("일별", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            return button
        }()

        weeklyBoxOfficeButton = {
            let button = UIButton()
            button.setTitle("주간", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            return button
        }()
        
        indicatorView.backgroundColor = .lightGray
        
        boxOfficeTableView.delegate = self
        
        navigationItem.title = "박스오피스"
        navigationItem.backButtonTitle = ""
    }
    
    private func initLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        [headerView, boxOfficeTableView].forEach {
            view.addSubview($0)
        }
        
        [dayRangeLabel, dailyBoxOfficeButton, weeklyBoxOfficeButton, indicatorView].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeArea)
            $0.bottom.equalTo(dailyBoxOfficeButton.snp.bottom)
        }
        
        dayRangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        dailyBoxOfficeButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(dayRangeLabel.snp.bottom).offset(4)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(40)
        }
        
        weeklyBoxOfficeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(dailyBoxOfficeButton)
            $0.width.equalTo(dailyBoxOfficeButton)
            $0.height.equalTo(40)
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        boxOfficeTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(headerView.snp.bottom)
        }
    }

}


extension HomeViewController: UITableViewDelegate {
    
}
