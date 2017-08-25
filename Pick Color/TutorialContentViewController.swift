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
    
    var image = UIImage()
    var text = String()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = text
        imageView.image = image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
