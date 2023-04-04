//
//  OneLabelCollectionViewCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit
import Common

open class OneLabelCollectionViewCell: UICollectionViewCell {
    
    public static let cellID = "OneLabelCollectionViewCell"
    
    private var movieNameLabel = UILabel()
    
    public var code: String = ""
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(title: String) {
        movieNameLabel.text = title
    }
    
    public func bind(bookMark: BookMark) {
        movieNameLabel.text = bookMark.title
        code = bookMark.code
    }
    
    private func initAttribute() {
        movieNameLabel.textColor = .black
        movieNameLabel.textAlignment = .center
    }
    
    private func initConstraint() {
        contentView.addSubview(movieNameLabel)
        
        movieNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
