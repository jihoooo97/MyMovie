//
//  SearchMovieTableView.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/30.
//

import UIKit

open class SearchMovieTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(SearchMovieCell.self, forCellReuseIdentifier: SearchMovieCell.cellID)
        rowHeight = 56
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
