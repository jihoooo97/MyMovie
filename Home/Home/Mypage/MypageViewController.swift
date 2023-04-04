//
//  MypageViewController.swift
//  Home
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit
import Common
import UIComponent
import RxSwift
import RxCocoa

fileprivate enum MySection {
    case first([FirstItem])
    
    struct FirstItem {
        let value: [BookMark]
    }
}

open class MypageViewController: UIViewController {
    
    fileprivate struct Constant {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(56))
    }
    
    fileprivate let dataSource: [MySection] = [
        .first(
            [[BookMark(title: "스즈메의 문단속", code: "20226270"),
              BookMark(title: "던전 앤 드래곤: 도적들의 명예", code: "20226410"),
              BookMark(title: "옹남이", code: "20210544"),
              BookMark(title: "해피 투게더", code: "20080269"),
              BookMark(title: "스즈메의 문단속", code: "20226270"),
              BookMark(title: "던전 앤 드래곤: 도적들의 명예", code: "20226410"),
              BookMark(title: "옹남이", code: "20210544"),
              BookMark(title: "해피 투게더", code: "20080269"),
              BookMark(title: "스즈메의 문단속", code: "20226270"),
              BookMark(title: "던전 앤 드래곤: 도적들의 명예", code: "20226410"),
              BookMark(title: "옹남이", code: "20210544"),
              BookMark(title: "해피 투게더", code: "20080269"),
              BookMark(title: "스즈메의 문단속", code: "20226270"),
              BookMark(title: "던전 앤 드래곤: 도적들의 명예", code: "20226410"),
              BookMark(title: "옹남이", code: "20210544"),
              BookMark(title: "해피 투게더", code: "20080269")],
             [BookMark(title: "더 퍼스트 슬램덩크", code: "20228555"),
              BookMark(title: "리바운드", code: "20226489"),
              BookMark(title: "오토라는 남자", code: "20230641"),
              BookMark(title: "소울메이트", code: "20197654")]].map(MySection.FirstItem.init(value:))
        )
    ]
    
    var bookmarkCollectionView = InnerCollectionView()
    var stickyView = StickyView()
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
        bind()
    }
    
    
    private func bind() { 
        bookmarkCollectionView.rx.willEndDragging
            .withUnretained(self).map { $0 }
            .map { ($0.0, $0.1.targetContentOffset) }
            .bind(onNext: { vc, offset in
                let width = vc.bookmarkCollectionView.frame.width
                let page = Int(offset.pointee.x / width)
                vc.stickyView.tagRelay.accept(page)
            }).disposed(by: disposeBag)
        
        stickyView.tagRelay
            .withUnretained(self).map { $0 }
            .bind(onNext: { vc, tag in
                let offset = vc.view.frame.width * CGFloat(tag)
                vc.bookmarkCollectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        view.backgroundColor = .white
        
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [stickyView, bookmarkCollectionView].forEach {
            view.addSubview($0)
        }
        
        stickyView.snp.makeConstraints {
            $0.left.right.top.equalTo(safeArea)
            $0.height.equalTo(56)
        }
        
        bookmarkCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(safeArea)
            $0.top.equalTo(stickyView.snp.bottom)
        }
    }
    
}


extension MypageViewController: UICollectionViewDelegate { }

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = CGFloat(collectionView.frame.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
}

extension MypageViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch dataSource[section] {
        case let .first(items):
            return items.count
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch self.dataSource[indexPath.section] {
        case let .first(items):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InnerCollectionViewCell.cellID,
                for: indexPath
            ) as! InnerCollectionViewCell
            cell.bind(bookMarkList: items[indexPath.item].value)
            cell.delegate = self
            return cell
        }
    }
    
}

extension MypageViewController: InnerCollectionViewCellDelegate {
    
    func showDetail(bookMark: BookMark) {
        let viewModel = MovieDetailViewModel(useCase: MovieUseCase())
        viewModel.getMovieInfo(movieCode: bookMark.code)
        let detailViewController = MovieDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
