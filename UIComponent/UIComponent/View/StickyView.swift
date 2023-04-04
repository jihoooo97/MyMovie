//
//  StickyView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/31.
//

import UIKit
import Common
import RxSwift
import RxCocoa

open class StickyView: UIView {

    var movieButton = UIButton()
    var actorButton = UIButton()
    public var indicatorView = UIView()
    
    public var tagRelay = BehaviorRelay<Int>(value: 0)
    private var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
        initConstraint()
        bind()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        Observable.of(
            movieButton.rx.tap.map { [weak self] _ in return self?.movieButton.tag },
            actorButton.rx.tap.map { [weak self] _ in return self?.actorButton.tag }
        ).merge().bind { [weak self] tag in
            guard let tag else { return }
            self?.tagRelay.accept(tag)
        }.disposed(by: disposeBag)
            
        tagRelay
            .distinctUntilChanged()
            .bind(onNext: { [weak self] tag in
            self?.movieButton.isSelected = tag == 0
            self?.actorButton.isSelected = tag == 1
            
            let width = (self?.frame.size.width)! / 2
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1,
                options: .curveEaseOut
            ) { [weak self] in
                self?.indicatorView.transform = CGAffineTransform(
                    translationX: width * CGFloat(tag),
                    y: 0
                )
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func initAttribute() {
        self.backgroundColor = .white
        
        movieButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            button.setTitle("영화", for: .normal)
            button.setTitleColor(MyColor.G200, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.isSelected = true
            button.tag = 0
            return button
        }()
        
        actorButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            button.setTitle("배우", for: .normal)
            button.setTitleColor(MyColor.G200, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.tag = 1
            return button
        }()
        
        indicatorView = {
            let view = UIView()
            view.backgroundColor = .systemBlue
            view.layer.cornerRadius = 2
            return view
        }()
    }
    
    private func initConstraint() {
        [movieButton, actorButton, indicatorView].forEach {
            self.addSubview($0)
        }
        
        movieButton.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(self.snp.centerX)
        }

        actorButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(self.snp.centerX)
        }
        
        indicatorView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(movieButton)
            $0.height.equalTo(2)
        }
    }
    
}
