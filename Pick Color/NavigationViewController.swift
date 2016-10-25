//
//  NavigationViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 13/8/15.
//  Copyright (c) 2015 Liuliet.Lee. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor(rgb: 0x66ccff)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let color = UIColor.black.cgColor
        navigationBar.layer.shadowColor = color
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        navigationBar.layer.shadowRadius = 1.5
        navigationBar.layer.shadowOpacity = 1.0
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
