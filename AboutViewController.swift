//
//  AboutViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 11/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    /// - important: need to update with button tag
    private let links = [
        "https://www.facebook.com/liuliet.lee",
        "http://space.bilibili.com/4056345/#!/index",
        "https://github.com/LiulietLee/Pick-Color"
    ]

    @IBAction func openLink(associatedWith button: UIButton){
        UIApplication.shared.openURL(URL(string: links[(button.tag < links.count ? button.tag : 0)])!)
    }

}
