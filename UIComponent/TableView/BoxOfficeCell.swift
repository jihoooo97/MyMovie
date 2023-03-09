//
//  BoxOfficeCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/06.
//

import UIKit
import Common
import SnapKit

open class BoxOfficeCell: BaseTableViewCell {

    public static let cellID = "BoxOfficeCell"
    
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
            $0.leading.trailing.bottom.equalTo(contentView)
            $0.height.equalTo(1)
        }
    }
    
    public func bind(boxOffice: BoxOffice) {
        movieNameLabel.text = boxOffice.movieNm
    }
    
    fileprivate func initAttribute() {
        backgroundColor = .white
        selectionStyle = .none
        
        movieNameLabel.textColor = .black
        
        indicatorView.backgroundColor = .lightGray
    }
    
}
