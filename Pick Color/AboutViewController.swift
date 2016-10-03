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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func githubButtonTapped() {
        UIApplication.shared.openURL(URL(string: "https://github.com/LiulietLee/Pick-Color")!)
    }
    
    @IBAction func facebookButtonTapped() {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/liuliet.lee")!)
    }

    @IBAction func bilibiliButtonTapped() {
        UIApplication.shared.openURL(URL(string: "http://space.bilibili.com/4056345/#!/index")!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
