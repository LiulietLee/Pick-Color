//
//  SourceViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 3/4/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    fileprivate let project: [ (name: String, url: String) ] = [
        ("LiulietLee/Pick-Color", "https://github.com/LiulietLee/Pick-Color"),
        ("LiulietLee/LLDialog", "https://github.com/LiulietLee/LLDialog"),
        ("ApolloZhu/MaterialKit", "https://github.com/ApolloZhu/MaterialKit"),
        ("John-Lluch/SWRevealViewController", "https://github.com/John-Lluch/SWRevealViewController"),
        ("bahlo/SwiftGif", "https://github.com/bahlo/SwiftGif")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProjectUrlCell
        cell.labelText.text = project[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.openURL(URL(string: project[indexPath.row].url)!)
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
