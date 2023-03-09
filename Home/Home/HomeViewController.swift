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
    var boxOfficeTypeLabel = UILabel()
    var dailyBoxOfficeButton = UIButton()
    var weeklyBoxOfficeButton = UIButton()
    var indicatorView = UIView()
    var boxOfficeTableView = BoxOfficeTableView()
    
    fileprivate let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initLayout()
        bind()
    }
    
    private func bind() {
        viewModel.getDailyMovieList(targetDt: DateParser.getOneDayBeforeDate())
        
        viewModel.dayRangeRelay
            .bind(to: dayRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.boxOfficeRelay
            .bind(to: boxOfficeTableView.rx.items(cellIdentifier: BoxOfficeCell.cellID,
                                                  cellType: BoxOfficeCell.self)
            ) { (index, item, cell) in
                cell.bind(boxOffice: item)
            }.disposed(by: disposeBag)
        
        viewModel.boxOfficeType
            .bind(onNext: { [weak self] type in
                self?.dailyBoxOfficeButton.isSelected = type.first! == "일"
                self?.weeklyBoxOfficeButton.isSelected = type.first! == "주"
            }).disposed(by: disposeBag)
        
        dailyBoxOfficeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.getDailyMovieList(targetDt: DateParser.getOneDayBeforeDate())
            }).disposed(by: disposeBag)

        weeklyBoxOfficeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.getWeeklyMovieList(targetDt: DateParser.getOneWeekBeforeDate())
            }).disposed(by: disposeBag)
        
        boxOfficeTableView.rx.itemSelected
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map{ [weak self] in
                (self?.viewModel.boxOfficeRelay.value[$0.row])!
            }
            .bind(onNext: { item in
                print(item.movieNm ?? "none")
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
        
        headerView.backgroundColor = .white
        
        boxOfficeTypeLabel.text = "박스오피스"
        boxOfficeTypeLabel.textColor = .systemBlue
        
        dayRangeLabel.textColor = .lightGray
        
        dailyBoxOfficeButton.setTitle("일별", for: .normal)
        dailyBoxOfficeButton.setTitleColor(.black, for: .normal)
        dailyBoxOfficeButton.setTitleColor(.systemBlue, for: .selected)
        
        weeklyBoxOfficeButton.setTitle("주간", for: .normal)
        weeklyBoxOfficeButton.setTitleColor(.black, for: .normal)
        weeklyBoxOfficeButton.setTitleColor(.systemBlue, for: .selected)
        
        boxOfficeTableView.delegate = self
    }
    
    private func initLayout() {
        let safeArea = view.layoutMarginsGuide
        
        [headerView, boxOfficeTableView].forEach {
            view.addSubview($0)
        }
        
        [boxOfficeTypeLabel, dayRangeLabel, dailyBoxOfficeButton, weeklyBoxOfficeButton].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeArea)
            $0.bottom.equalTo(dailyBoxOfficeButton.snp.bottom)
        }
        
        boxOfficeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        dayRangeLabel.snp.makeConstraints {
            $0.top.equalTo(boxOfficeTypeLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        dailyBoxOfficeButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(dayRangeLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(40)
        }
        
        weeklyBoxOfficeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(dailyBoxOfficeButton)
            $0.width.equalTo(dailyBoxOfficeButton)
            $0.height.equalTo(40)
        }
        
        boxOfficeTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(headerView.snp.bottom)
        }
    }

}


extension HomeViewController: UITableViewDelegate {
    
}
