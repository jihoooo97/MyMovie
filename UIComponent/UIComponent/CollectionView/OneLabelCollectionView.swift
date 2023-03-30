//
//  OneLabelCollectionView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit

open class OneLabelCollectionView: UICollectionView {

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
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .vertical
        collectionViewLayout = flowLayout
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        register(OneLabelCollectionViewCell.self,
                 forCellWithReuseIdentifier: OneLabelCollectionViewCell.cellID)
        register(MypageHeaderView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: MypageHeaderView.id)
    }

}
