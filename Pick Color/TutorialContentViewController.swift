//
//  TutorialContentViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 25/8/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var gifName = String()
    var text = String()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = text
        imageView.loadGif(name: gifName)
    }

}
