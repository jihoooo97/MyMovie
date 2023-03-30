//
//  NavigationController.swift
//  UIComponent
//
//  Created by 유지호 on 2023/03/12.
//

import UIKit

open class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        isNavigationBarHidden = true
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .systemBlue
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    }
    
    

}


extension NavigationController: UINavigationControllerDelegate {
    
    
}
