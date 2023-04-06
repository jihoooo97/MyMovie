//
//  InnerCollectionViewCell.swift
//  Home
//
//  Created by 유지호 on 2023/04/01.
//

import UIKit
import Common
import UIComponent
import RxSwift
import RxCocoa

protocol InnerCollectionViewCellDelegate: NSObjectProtocol {
    func showDetail(bookMark: BookMark)
}

open class InnerCollectionViewCell: UICollectionViewCell {
    
    public static let cellID = "InnerCollectionViewCell"
    weak var delegate: InnerCollectionViewCellDelegate?
    
    public var collectionView = OneLabelCollectionView()
    
    public var bookMarkListRelay = BehaviorRelay<[BookMark]>(value: [])
    fileprivate var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
        bind()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(bookMarkList: [BookMark]) {
        bookMarkListRelay.accept(bookMarkList)
    }
    
    private func bind() {
        bookMarkListRelay.bind(to: collectionView.rx.items(
            cellIdentifier: OneLabelCollectionViewCell.cellID,
            cellType: OneLabelCollectionViewCell.self
        )) { index, data, cell in
            cell.bind(bookMark: data)
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(BookMark.self)
            .withUnretained(self).map { $0 }
            .bind(onNext: { cell, bookMark in
                cell.delegate?.showDetail(bookMark: bookMark)
            }).disposed(by: disposeBag)
    }
    
    private func initAttribute() {
//        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        backgroundColor = .brown
    }
    
    private func initConstraint() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension InnerCollectionViewCell: UICollectionViewDelegate { }

extension InnerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        return CGSize(width: self.frame.width, height: 50)
//    }
    
}
