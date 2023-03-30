//
//  MypageHeaderView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/26.
//

import UIKit
import Common

open class MypageHeaderView: UICollectionReusableView {
        
    public static let id = "MypageHeaderView"
    
    var bookmarkTitleLabel = UILabel()
    
    var bookmarkMovieTitleLabel = UILabel()
    var bookmarkMovieLabel = UILabel()
    
    var bookmarkActorTitleLabel = UILabel()
    var bookmarkActorLabel = UILabel()
    
    var stickyView = UIView()
    private var bottomIndicatorView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initAttribute() {
        backgroundColor = .clear
        
        bookmarkTitleLabel = {
            let label = UILabel()
            label.text = "즐겨찾기"
            label.textColor = .black
            label.textAlignment = .center
            label.font = MyFont.SubTitle1
            return label
        }()
        
        bookmarkMovieTitleLabel = {
            let label = UILabel()
            label.text = "영화 수"
            label.textColor = .black
            label.textAlignment = .center
            label.font = MyFont.SubTitle1
            return label
        }()
        
        bookmarkMovieLabel = {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = MyFont.Body1
            return label
        }()
        
        bookmarkActorTitleLabel = {
            let label = UILabel()
            label.text = "배우 수"
            label.textColor = .black
            label.textAlignment = .center
            label.font = MyFont.SubTitle1
            return label
        }()
        
        bookmarkActorLabel = {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = MyFont.Body1
            return label
        }()
        
        stickyView.backgroundColor = .systemBlue
        
        bottomIndicatorView = {
            let view = UIView()
            view.backgroundColor = MyColor.G100
            return view
        }()
    }
    
    private func initConstraint() {
        [bookmarkTitleLabel,
         bookmarkMovieLabel, bookmarkMovieTitleLabel,
         bookmarkActorLabel, bookmarkActorTitleLabel,
         stickyView, bottomIndicatorView].forEach {
            self.addSubview($0)
        }
        
        bookmarkTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        bookmarkMovieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkTitleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(bookmarkTitleLabel.snp.leading).offset(-8)
        }
        
        bookmarkMovieLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkMovieTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(bookmarkMovieTitleLabel)
        }
        
        bookmarkActorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkMovieTitleLabel)
            $0.leading.equalTo(bookmarkTitleLabel.snp.trailing).offset(8)
        }
        
        bookmarkActorLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkActorTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(bookmarkActorTitleLabel)
        }
        
        stickyView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        bottomIndicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
}
