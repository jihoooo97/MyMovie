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
    
    
    // MARK: Constraint
    private struct Constraint {
        static let boxOfficeButtonHeight = 40.0
        static let indicatorHeight = 0.5
    }
    
    // MARK: View
    var titleStackView = UIStackView()
    var titleLabel = UILabel()
    var dayRangeLabel = UILabel()
    
    var headerView = UIView()
    var dailyBoxOfficeButton = UIButton()
    var weeklyBoxOfficeButton = UIButton()
    var indicatorView = UIView()
    var boxOfficeTableView = OneLabelTableView()
    
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
        bind()
    }
    
    private func bind() {
        viewModel.dayRangeRelay
            .bind(to: dayRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.boxOfficeRelay
            .bind(to: boxOfficeTableView.rx.items(
                cellIdentifier: OneLabelCell.cellID,
                cellType: OneLabelCell.self
            )) { (index, item, cell) in
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
                let viewModel = MovieDetailViewModel(useCase: MovieUseCase())
                viewModel.getMovieInfo(movieCode: item.movieCd)
                let movieDetailView = MovieDetailViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(movieDetailView, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        
        titleStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .clear
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        titleLabel = {
            let label = UILabel()
            label.text = "박스오피스"
            label.font = MyFont.SubTitle2
            label.textColor = .systemBlue
            label.textAlignment = .center
            return label
        }()
        
        dayRangeLabel = {
            let label = UILabel()
            label.font = MyFont.Caption3
            label.textColor = .lightGray
            label.textAlignment = .center
            return label
        }()
        
        headerView.backgroundColor = .clear
        
        dailyBoxOfficeButton = {
            let button = UIButton()
            button.setTitle("일별", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            button.backgroundColor = .clear
            return button
        }()

        weeklyBoxOfficeButton = {
            let button = UIButton()
            button.setTitle("주간", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            button.backgroundColor = .clear
            return button
        }()
        
        indicatorView.backgroundColor = .systemGray
        
        boxOfficeTableView.delegate = self
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [titleLabel, dayRangeLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        navigationItem.titleView = titleStackView
        
        [headerView, boxOfficeTableView].forEach {
            view.addSubview($0)
        }
        
        [dailyBoxOfficeButton, weeklyBoxOfficeButton, indicatorView].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeArea)
            $0.bottom.equalTo(dailyBoxOfficeButton.snp.bottom)
        }
        
        dailyBoxOfficeButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(headerView)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(Constraint.boxOfficeButtonHeight)
        }
        
        weeklyBoxOfficeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(dailyBoxOfficeButton)
            $0.width.equalTo(dailyBoxOfficeButton)
            $0.height.equalTo(Constraint.boxOfficeButtonHeight)
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constraint.indicatorHeight)
        }
        
        boxOfficeTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(headerView.snp.bottom)
        }
    }

}


extension HomeViewController: UITableViewDelegate { }
