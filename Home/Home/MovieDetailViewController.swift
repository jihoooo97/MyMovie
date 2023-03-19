//
//  MoviewDetailViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/12.
//

import UIKit
import Common
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
    
    
    // MARK: Constraint
    
    private struct Constraint {
        
    }
    
    
    // MARK: View
    
    private var infoView = UIView()
    private var titleLabel = UILabel()
    
    private var infoTitleLabel = UILabel()
    private var genreLabel = UILabel()
    private var nationLabel = UILabel()
    private var showTimeLabel = UILabel()
    
    private var openDateTitleLabel = UILabel()
    private var openDateLabel = UILabel()
    
    private var actorStack = UIStackView()
    private var directorStack = UIStackView()
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        initAttribute()
        initConstraint()
    }
    
    
    private func bind() {
        viewModel.movieInfoRelay
            .bind(onNext: { [weak self] movie in
                self?.navigationItem.title = movie.movieNm
                self?.genreLabel.text = movie.genres.compactMap { $0.genreNm }.joined(separator: "/")
                self?.nationLabel.text = movie.nations.first?.nationNm ?? "없음"
                self?.showTimeLabel.text = movie.showTm + "분"
                self?.openDateLabel.text = movie.openDt
                
                movie.actors.forEach {
                    let label = BorderLabel()
                    label.text = $0.peopleNm
                    self?.actorStack.addArrangedSubview(label)
                }
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
        
        infoView = {
            let view = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.cornerRadius = 8
            return view
        }()
        
        titleLabel = {
            let label = UILabel()
            label.text = "기본 정보"
            label.font = MyFont.SubTitle1
            return label
        }()

        infoTitleLabel = {
            let label = UILabel()
            label.text = "개요"
            label.textColor = .lightGray
            label.font = MyFont.Body1
            return label
        }()
        
        openDateTitleLabel = {
            let label = UILabel()
            label.text = "개봉"
            label.textColor = .lightGray
            label.font = MyFont.Body1
            return label
        }()
        
        genreLabel.font = MyFont.Body1
        nationLabel.font = MyFont.Body1
        showTimeLabel.font = MyFont.Body1
        openDateLabel.font = MyFont.Body1
        
        actorStack = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            return stackView
        }()
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [infoView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, infoTitleLabel, openDateTitleLabel,
         genreLabel, nationLabel, showTimeLabel,
         openDateLabel, actorStack].forEach {
            infoView.addSubview($0)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(safeArea).offset(8)
            $0.bottom.equalTo(actorStack).offset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(8)
        }
        
        infoTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel).offset(8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        openDateTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel).offset(8)
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(8)
        }
        
        genreLabel.snp.makeConstraints {
            $0.leading.equalTo(infoTitleLabel.snp.trailing).offset(8)
            $0.top.equalTo(infoTitleLabel)
        }
        
        nationLabel.snp.makeConstraints {
            $0.leading.equalTo(genreLabel.snp.trailing).offset(12)
            $0.top.equalTo(infoTitleLabel)
        }
        
        showTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(nationLabel.snp.trailing).offset(12)
            $0.top.equalTo(infoTitleLabel)
        }
        
        openDateLabel.snp.makeConstraints {
            $0.leading.equalTo(openDateTitleLabel.snp.trailing).offset(8)
            $0.top.equalTo(openDateTitleLabel)
        }
        
        actorStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.equalTo(openDateTitleLabel.snp.bottom).offset(8)
            $0.height.equalTo(36)
        }
    }

}
