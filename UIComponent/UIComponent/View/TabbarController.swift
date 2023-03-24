//
//  TabbarController.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/24.
//

import UIKit

open class TabbarController: UITabBarController {

    private var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .white
        tabBarItem.badgeColor = .systemBlue
        
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.equalTo(tabBar)
            $0.top.equalTo(tabBar)
            $0.height.equalTo(0.5)
        }
    }

}
