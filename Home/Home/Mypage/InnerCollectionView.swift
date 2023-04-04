//
//  InnerCollectionView.swift
//  Home
//
//  Created by 유지호 on 2023/03/31.
//

import UIKit
import UIComponent

class InnerCollectionView: UICollectionView {

    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(
            frame: frame,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        initAttribute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func initAttribute() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        collectionViewLayout = flowLayout
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        register(OneLabelCollectionViewCell.self,
                 forCellWithReuseIdentifier: OneLabelCollectionViewCell.cellID)
        register(InnerCollectionViewCell.self,
                 forCellWithReuseIdentifier: InnerCollectionViewCell.cellID)
        register(MypageHeaderView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: MypageHeaderView.id)
        register(MypageFooterView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: MypageFooterView.id)
    }

}
