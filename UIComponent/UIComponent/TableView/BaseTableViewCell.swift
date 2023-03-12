//
//  BaseTableViewCell.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/10.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
    }
    
    public required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
