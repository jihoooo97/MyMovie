//
//  TabbarCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit
import Common

open class TabbarCell: UICollectionViewCell {
    
    public static let cellID = "TabbarCell"
    
    private var titleLabel = UILabel()
    
    open override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : MyColor.G200
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(title: String) {
        titleLabel.text = title
    }
    
    private func initAttribute() {
        titleLabel.textColor = MyColor.G200
        titleLabel.textAlignment = .center
    }
    
    private func initConstraint() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
