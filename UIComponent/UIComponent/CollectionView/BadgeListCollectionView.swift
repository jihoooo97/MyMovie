//
//  BadgeListCollectionView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/23.
//

import UIKit

open class BadgeListCollectionView: UICollectionView {

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
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        collectionViewLayout = flowLayout
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        register(BadgeListCell.self, forCellWithReuseIdentifier: BadgeListCell.cellID)
    }
    
}
