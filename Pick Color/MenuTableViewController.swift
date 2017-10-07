//
//  MenuTableViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 26/8/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    fileprivate var menuList: [(title: String, id: String)] = [
        ("Pick Color", "picker"),
        ("Favorite", "favorites"),
        ("Author", "author"),
        ("Rate PickColor", "rate"),
        ("Source Code", "code")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuList[indexPath.row].id, for: indexPath) as! MenuCell
        
        cell.title?.text = menuList[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 10.3, *) {
            return
        }
        
        if indexPath.row == 3 {
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
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.3, *), menuList[3].id == "rate" {
            menuList.remove(at: 3)
        }
    }
    
}
