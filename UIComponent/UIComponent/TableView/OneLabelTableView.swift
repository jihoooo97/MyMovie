//
//  BoxOfficeTableView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/06.
//

import UIKit

open class OneLabelTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(OneLabelCell.self, forCellReuseIdentifier: OneLabelCell.cellID)
        register(TableViewLoadingFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewLoadingFooterView.id)
        rowHeight = 56
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
