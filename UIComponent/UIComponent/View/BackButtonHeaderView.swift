//
//  BackButtonView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/12.
//

import UIKit
import SnapKit

open class BackButtonHeaderView: UIView {

    public var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ""), for: .normal)
        return button
    }()
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        initConstraint()
    }
    
    private func initConstraint() {
        [backButton, titleLabel, indicatorView].forEach {
            self.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
}
