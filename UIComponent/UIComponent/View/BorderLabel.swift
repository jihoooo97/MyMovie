//
//  BorderLabel.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/19.
//

import UIKit
import Common

open class BorderLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttribute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    
    private func initAttribute() {
        textAlignment = .center
        font = MyFont.Button
        textColor = .systemBlue
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 8
    }
    
}
