//
//  TabbarController.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/24.
//

import UIKit

open class TabbarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()

//        tabBar.barTintColor = .white
        tabBarItem.badgeColor = .systemBlue
    }

}
