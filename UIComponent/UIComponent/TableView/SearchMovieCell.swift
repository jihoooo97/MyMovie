//
//  SearchMovieCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/30.
//

import UIKit
import Common

open class SearchMovieCell: BaseTableViewCell {

    public static let cellID = "SearchMovieCell"
    
    private struct Constraint {
        static let leftRight = 8.0
        static let indicatorHeight = 0.5
    }
    
    fileprivate let movieNameLabel = UILabel()
    fileprivate let genreLabel = BorderLabel()
    fileprivate let indicatorView = UIView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initAttribute()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        [genreLabel, movieNameLabel, indicatorView].forEach {
            contentView.addSubview($0)
        }
        
        movieNameLabel.snp.makeConstraints {
            $0.left.equalTo(indicatorView).offset(Constraint.leftRight)
            $0.right.equalTo(genreLabel.snp.left).offset(-Constraint.leftRight)
            $0.centerY.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.right.equalTo(indicatorView).offset(-Constraint.leftRight)
            $0.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraint.leftRight)
            $0.trailing.equalToSuperview().offset(-Constraint.leftRight)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constraint.indicatorHeight)
        }
    }
    
    public func bind(movie: SearchMovieResponse) {
        movieNameLabel.text = "\(movie.movieNm) (\(movie.prdtYear))"
        genreLabel.text = movie.repGenreNm == "" ? "기타" : movie.repGenreNm
    }
    
    fileprivate func initAttribute() {
        backgroundColor = .white
        selectionStyle = .none
        
        movieNameLabel.textColor = .black
        
        indicatorView.backgroundColor = .systemGray5
    }
}
