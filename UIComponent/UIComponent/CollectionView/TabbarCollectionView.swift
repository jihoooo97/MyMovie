//
//  TabbarCollectionView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit
import RxSwift
import RxCocoa

open class TabbarCollectionView: UICollectionView {

    private var tabTitleListRelay = BehaviorRelay<[String]>(value: [])
    
    private var disposeBag = DisposeBag()
    
    public init(_ tabTitles: [String]) {
        super.init(
            frame: .zero,
            collectionViewLayout: .init()
        )
        tabTitleListRelay.accept(tabTitles)
        
        initAttribute()
        bind()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        tabTitleListRelay.bind(to: self.rx.items(
            cellIdentifier: TabbarCell.cellID,
            cellType: TabbarCell.self
        )) { index, data, cell in
            cell.isSelected = index == 0
            cell.bind(title: data)
            print(cell.isSelected)
        }.disposed(by: disposeBag)
    }
    
    private func initAttribute() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        collectionViewLayout = flowLayout
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        register(TabbarCell.self, forCellWithReuseIdentifier: TabbarCell.cellID)
    }

}
