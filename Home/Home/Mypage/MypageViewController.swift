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
    
    var innerScrollingDownDueToOuterScroll = false
    
    var outerScrollView = UIScrollView()
    var contentView = UIStackView()
    var profileView = UIView()
    var stickyViewFrame = UIView()
    var tabViewFrame = UIView()
    var stickyView = StickyView()
    var bookmarkCollectionView = InnerCollectionView()
    
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initAttribute()
        initConstraint()
        bind()
    }
    
    
    private func bind() {
        outerScrollView.rx.didScroll
            .withUnretained(self).map { $0.0 }
            .map { ($0, $0.outerScrollView.contentOffset.y) }
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { vc, offset in
                if offset > vc.tabViewFrame.frame.minY {
                    vc.stickyViewFrame.addSubview(vc.stickyView)
                    vc.stickyViewFrame.isHidden = false
                } else {
                    vc.tabViewFrame.addSubview(vc.stickyView)
                    vc.stickyViewFrame.isHidden = true
                }
                vc.stickyView.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                }
            }).disposed(by: disposeBag)
        
        bookmarkCollectionView.rx.didScroll
            .withUnretained(self).map { $0.0 }
            .map { ($0, $0.bookmarkCollectionView.contentOffset.y) }
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { vc, offset in
            }).disposed(by: disposeBag)
        
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
        
        outerScrollView.delegate = self
        
        stickyViewFrame.backgroundColor = .systemBlue
        stickyViewFrame.isHidden = true
        
        tabViewFrame.backgroundColor = .systemRed
        
        contentView.axis = .vertical
        contentView.backgroundColor = .clear
        
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
    }
    
    private func initConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        [outerScrollView, stickyViewFrame].forEach {
            view.addSubview($0)
        }
        outerScrollView.addSubview(contentView)
        
        [profileView, tabViewFrame, bookmarkCollectionView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        outerScrollView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        
        stickyViewFrame.snp.makeConstraints {
            $0.left.right.top.equalTo(safeArea)
            $0.height.equalTo(56)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.equalTo(safeArea)
        }
        
        profileView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        tabViewFrame.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
    
}


extension MypageViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // more, less 스크롤 방향의 기준: 새로운 콘텐츠로 스크롤링하면 more, 이전 콘텐츠로 스크롤링하면 less
        // ex) more scroll 한다는 의미: 손가락을 아래에서 위로 올려서 새로운 콘텐츠를 확인한다
        
        let outerScroll = outerScrollView == scrollView
        let innerScroll = !outerScroll
        let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let lessScroll = !moreScroll
        if let cell = (bookmarkCollectionView.visibleCells
            .map { $0 as! InnerCollectionViewCell }
            .sorted(by: { $0.collectionView.contentSize.height > $1.collectionView.contentSize.height })
            .first) {
            let cellCollectionView = cell.collectionView
            
            // outer scroll이 스크롤 할 수 있는 최대값 (이 값을 sticky header 뷰가 있다면 그 뷰의 frame.maxY와 같은 값으로 사용해도 가능)
            let outerScrollMaxOffsetY = tabViewFrame.frame.minY
            let innerScrollMaxOffsetY = cellCollectionView.contentSize.height - cellCollectionView.frame.height
            
            // 1. outer scroll을 more 스크롤
            // 만약 outer scroll을 more scroll 다 했으면, inner scroll을 more scroll
            if outerScroll && moreScroll {
                guard outerScrollMaxOffsetY < outerScrollView.contentOffset.y + 0.1 else { return }
                innerScrollingDownDueToOuterScroll = true
                defer { innerScrollingDownDueToOuterScroll = false }
                
                // innerScrollView를 모두 스크롤 한 경우 stop
                guard cellCollectionView.contentOffset.y < innerScrollMaxOffsetY else { return }
                
                cellCollectionView.contentOffset.y = cellCollectionView.contentOffset.y + outerScrollView.contentOffset.y - outerScrollMaxOffsetY
                outerScrollView.contentOffset.y = outerScrollMaxOffsetY
            }
            
            // 2. outer scroll을 less 스크롤
            // 만약 inner scroll이 less 스크롤 할게 남아 있다면 inner scroll을 less 스크롤
            if outerScroll && lessScroll {
                guard cellCollectionView.contentOffset.y > 0 && outerScrollView.contentOffset.y < outerScrollMaxOffsetY else { return }
                innerScrollingDownDueToOuterScroll = true
                defer { innerScrollingDownDueToOuterScroll = false }
                
                // outer scroll에서 스크롤한 만큼 inner scroll에 적용
                cellCollectionView.contentOffset.y = max(cellCollectionView.contentOffset.y - (outerScrollMaxOffsetY - outerScrollView.contentOffset.y), 0)
                
                // outer scroll은 스크롤 되지 않고 고정
                outerScrollView.contentOffset.y = outerScrollMaxOffsetY
            }
            
            // 3. inner scroll을 less 스크롤
            // inner scroll을 모두 less scroll한 경우, outer scroll을 less scroll
            if innerScroll && lessScroll {
                defer { cellCollectionView.lastOffsetY = cellCollectionView.contentOffset.y }
                guard cellCollectionView.contentOffset.y < 0 && outerScrollView.contentOffset.y > 0 else { return }
                
                // innerScrollView의 bounces에 의하여 다시 outerScrollView가 당겨질수 있으므로 bounces로 다시 되돌아가는 offset 방지
                guard cellCollectionView.lastOffsetY > cellCollectionView.contentOffset.y else { return }
                
                let moveOffset = outerScrollMaxOffsetY - abs(cellCollectionView.contentOffset.y) * 3
                guard moveOffset < outerScrollView.contentOffset.y else { return }
                
                outerScrollView.contentOffset.y = max(moveOffset, 0)
            }
            
            // 4. inner scroll을 more 스크롤
            // outer scroll이 아직 more 스크롤할게 남아 있다면, innerScroll을 그대로 두고 outer scroll을 more 스크롤
            if innerScroll && moreScroll {
                guard outerScrollView.contentOffset.y + 0.1 < outerScrollMaxOffsetY,
                      !innerScrollingDownDueToOuterScroll else { return }
                // outer scroll를 more 스크롤
                let minOffetY = min(outerScrollView.contentOffset.y + cellCollectionView.contentOffset.y, outerScrollMaxOffsetY)
                let offsetY = max(minOffetY, 0)
                outerScrollView.contentOffset.y = offsetY
                
                // inner scroll은 스크롤 되지 않아야 하므로 0으로 고정
                cellCollectionView.contentOffset.y = 0
            }
            
            // todo: scroll to top 시, inner scroll도 top으로 스크롤
        }
    }
    
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == bookmarkCollectionView {
            let height = CGFloat(collectionView.frame.height)
            return CGSize(width: view.frame.width, height: height)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
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
            cell.collectionView.delegate = self
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

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}

extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
