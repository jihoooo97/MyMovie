//
//  BadgeListCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/23.
//

import UIKit
import Common

open class BadgeListCell: UICollectionViewCell {
    
    public static let cellID = "BadgeListCell"
    
    private var nameLabel = BorderLabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(name: String) {
        nameLabel.text = name
    }
    
    private func initAttribute() {}
    
    private func initConstraint() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
