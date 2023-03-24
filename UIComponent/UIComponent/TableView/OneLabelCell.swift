//
//  BoxOfficeCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/06.
//

import UIKit
import Common
import SnapKit

open class OneLabelCell: BaseTableViewCell {

    public static let cellID = "OneLabelCell"
    
    private struct Constraint {
        static let leftRight = 8.0
        static let indicatorHeight = 0.5
    }
    
    fileprivate let movieNameLabel = UILabel()
    fileprivate let indicatorView = UIView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initAttribute()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        [movieNameLabel, indicatorView].forEach {
            contentView.addSubview($0)
        }
        
        movieNameLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraint.leftRight)
            $0.trailing.equalToSuperview().offset(-Constraint.leftRight)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constraint.indicatorHeight)
        }
    }
    
    public func bind(boxOffice: BoxOffice) {
        movieNameLabel.text = boxOffice.movieNm
    }
    
    fileprivate func initAttribute() {
        backgroundColor = .white
        selectionStyle = .none
        
        movieNameLabel.textColor = .black
        
        indicatorView.backgroundColor = .systemGray5
    }
    
}
