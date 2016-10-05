//
//  NavigationViewController.swift
//  Emotions Keyboard
//
//  Created by Liuliet.Lee on 13/8/15.
//  Copyright (c) 2015 Liuliet.Lee. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(rgb: 0x66ccff)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let color: CGColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowColor = color
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        self.navigationBar.layer.shadowRadius = 1.5
        self.navigationBar.layer.shadowOpacity = 1.0
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
