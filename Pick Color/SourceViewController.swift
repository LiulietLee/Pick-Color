//
//  SourceViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 4/11/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let project = [
        ["LiulietLee/This app", "https://github.com/LiulietLee/Pick-Color"],
        ["LiulietLee/LLDialog", "https://github.com/LiulietLee/LLDialog"],
        ["nghialv/MaterialKit", "https://github.com/nghialv/MaterialKit"],
        ["John-Lluch/SWRevealViewController", "https://github.com/John-Lluch/SWRevealViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = project[indexPath.row][0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.openURL(URL(string: project[indexPath.row][1])!)
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
