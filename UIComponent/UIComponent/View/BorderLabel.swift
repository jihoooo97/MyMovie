//
//  BorderLabel.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/19.
//

import UIKit
import Common

open class BorderLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initAttribute() {
        textColor = .systemBlue
        font = MyFont.Button
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 8
    }
    
}
