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
        static let defaultLeftRight = 8.0
        static let defaultTopBottom = 8.0
        static let titleLabelTop = 16.0
        static let labelSpace = 12.0
        static let collectionViewTop = 4.0
        static let collectionViewHeight = 30.0
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
    
    private var watchGradeTitltLabel = UILabel()
    private var watchGradeLabel = UILabel()
    
    private var actorTitleLabel = UILabel()
    private var actorCollectionView = BadgeListCollectionView()
    
    private var directorTitleLabel = UILabel()
    private var directorCollectionView = BadgeListCollectionView()
    
    private var companyTitleLabel = UILabel()
    private var companyLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
        bind()
    }
    
    
    private func bind() {
        viewModel.movieInfoRelay
            .bind(onNext: { [weak self] movie in
                self?.navigationItem.title = movie.movieNm
                self?.genreLabel.text = movie.genres.compactMap { $0.genreNm }.joined(separator: "/")
                self?.nationLabel.text = movie.nations.first?.nationNm ?? "-"
                self?.showTimeLabel.text = movie.showTm + "분"
                self?.openDateLabel.text = movie.openDt
                self?.watchGradeLabel.text = movie.audits.first?.watchGradeNm ?? "-"
                self?.companyLabel.text = movie.companys.first?.companyNm ?? "-"
            }).disposed(by: disposeBag)
        
        viewModel.actorListRelay
            .bind(to: actorCollectionView.rx.items(
                cellIdentifier: BadgeListCell.cellID,
                cellType: BadgeListCell.self
            )) { index, data, cell in
                cell.bind(name: data.peopleNm)
            }.disposed(by: disposeBag)
        
        viewModel.directorListRelay
            .bind(to: directorCollectionView.rx.items(
                cellIdentifier: BadgeListCell.cellID,
                cellType: BadgeListCell.self
            )) { index, data, cell in
                cell.bind(name: data.peopleNm)
            }.disposed(by: disposeBag)
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
            label.textColor = .black
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
        
        genreLabel.font = MyFont.Body1
        nationLabel.font = MyFont.Body1
        showTimeLabel.font = MyFont.Body1
        
        openDateTitleLabel = {
            let label = UILabel()
            label.text = "개봉"
            label.textColor = .lightGray
            label.font = MyFont.Body1
            return label
        }()
        
        openDateLabel.font = MyFont.Body1
        
        watchGradeTitltLabel = {
            let label = UILabel()
            label.text = "등급"
            label.textColor = .lightGray
            label.font = MyFont.Body1
            return label
        }()
        
        watchGradeLabel.font = MyFont.Body1
        
        actorTitleLabel = {
            let label = UILabel()
            label.text = "출연"
            label.textColor = .black
            label.font = MyFont.SubTitle2
            return label
        }()
        
        directorTitleLabel = {
            let label = UILabel()
            label.text = "감독"
            label.textColor = .black
            label.font = MyFont.SubTitle2
            return label
        }()

        companyTitleLabel = {
            let label = UILabel()
            label.text = "제작사"
            label.textColor = .black
            label.font = MyFont.SubTitle2
            return label
        }()
        
        companyLabel.font = MyFont.Body1
        
        actorCollectionView.delegate = self
        directorCollectionView.delegate = self
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [infoView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, infoTitleLabel, openDateTitleLabel, watchGradeTitltLabel,
         genreLabel, nationLabel, showTimeLabel, openDateLabel, watchGradeLabel,
         actorTitleLabel, actorCollectionView,
         directorTitleLabel, directorCollectionView,
         companyTitleLabel, companyLabel].forEach {
            infoView.addSubview($0)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraint.defaultLeftRight)
            $0.trailing.equalToSuperview().offset(-Constraint.defaultLeftRight)
            $0.top.equalTo(safeArea).offset(Constraint.defaultTopBottom)
            $0.bottom.equalTo(companyLabel).offset(Constraint.defaultTopBottom)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(Constraint.defaultLeftRight)
        }
        
        infoTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel).offset(Constraint.defaultLeftRight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constraint.defaultTopBottom)
        }
        
        openDateTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(infoTitleLabel)
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(Constraint.defaultTopBottom)
        }
        
        watchGradeTitltLabel.snp.makeConstraints {
            $0.leading.equalTo(infoTitleLabel)
            $0.top.equalTo(openDateTitleLabel.snp.bottom).offset(Constraint.defaultTopBottom)
        }
        
        genreLabel.snp.makeConstraints {
            $0.leading.equalTo(infoTitleLabel.snp.trailing).offset(Constraint.defaultLeftRight)
            $0.top.equalTo(infoTitleLabel)
        }
        
        nationLabel.snp.makeConstraints {
            $0.leading.equalTo(genreLabel.snp.trailing).offset(Constraint.labelSpace)
            $0.top.equalTo(infoTitleLabel)
        }
        
        showTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(nationLabel.snp.trailing).offset(Constraint.labelSpace)
            $0.top.equalTo(infoTitleLabel)
        }
        
        openDateLabel.snp.makeConstraints {
            $0.leading.equalTo(openDateTitleLabel.snp.trailing).offset(Constraint.defaultLeftRight)
            $0.top.equalTo(openDateTitleLabel)
        }
        
        watchGradeLabel.snp.makeConstraints {
            $0.leading.equalTo(openDateLabel)
            $0.top.equalTo(watchGradeTitltLabel)
        }
        
        actorTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraint.defaultLeftRight)
            $0.top.equalTo(watchGradeLabel.snp.bottom).offset(Constraint.titleLabelTop)
        }
        
        actorCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraint.defaultLeftRight)
            $0.trailing.equalToSuperview().offset(-Constraint.defaultLeftRight)
            $0.top.equalTo(actorTitleLabel.snp.bottom).offset(Constraint.collectionViewTop)
            $0.height.equalTo(Constraint.collectionViewHeight)
        }
        
        directorTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(actorTitleLabel)
            $0.top.equalTo(actorCollectionView.snp.bottom).offset(Constraint.titleLabelTop)
        }
        
        directorCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(actorCollectionView)
            $0.top.equalTo(directorTitleLabel.snp.bottom).offset(Constraint.collectionViewTop)
            $0.height.equalTo(Constraint.collectionViewHeight)
        }
        
        companyTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(actorTitleLabel)
            $0.top.equalTo(directorCollectionView.snp.bottom).offset(Constraint.titleLabelTop)
        }
        
        companyLabel.snp.makeConstraints {
            $0.leading.equalTo(companyTitleLabel)
            $0.top.equalTo(companyTitleLabel.snp.bottom).offset(Constraint.collectionViewTop)
        }
    }

}

extension MovieDetailViewController: UICollectionViewDelegate { }

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var name = ""
        
        if collectionView == actorCollectionView {
            name = viewModel.actorListRelay.value[indexPath.row].peopleNm
        } else {
            name = viewModel.directorListRelay.value[indexPath.row].peopleNm
        }
        
        let word = name.filter { $0 != " " }
        let space = name.filter { $0 == " " }
        return CGSize(width: (word.count * 14) + (space.count * 4) + 4, height: 30)
    }
    
}
