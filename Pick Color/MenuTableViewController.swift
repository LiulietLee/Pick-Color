//
//  MenuTableViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 26/8/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            if #available(iOS 10.3, *) {
                return
            }
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1205136568") else {
                print("wtf?!")
                return
            }
            guard #available(iOS 10, *) else {
                UIApplication.shared.openURL(url)
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 10.3, *) {
            tableView.cellForRow(at: IndexPath(row: 4, section: 0))?.isHidden = true
        }
    }
    
}
