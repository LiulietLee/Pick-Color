//
//  MemoViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 15/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    fileprivate var model = CoreDataModel()
    fileprivate var colors = [Colors]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colors = model.fetchColors()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemoCell
        
        cell.colorName.text = colors[indexPath.row].title!
                
        let color = UIColor(red: colors[indexPath.row].red as! CGFloat,
                            green: colors[indexPath.row].green as! CGFloat,
                            blue: colors[indexPath.row].blue as! CGFloat,
                            alpha: colors[indexPath.row].alpha as! CGFloat)
        
        cell.colorLabel.backgroundColor = color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = colors[indexPath.row]
        model.deleteColor(item)        
        colors = model.fetchColors()
        tableView.reloadData()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        let dialog = LLDialog()
        
        dialog.title = "WARNING"
        dialog.message = "Do you really want to delete ALL the colors?"
        dialog.setPositiveButton(withTitle: "Yes", target: self, action: #selector(self.deleteAllItems))
        dialog.setNegativeButton(withTitle: "No")
        
        dialog.show()
    }
    
    @objc fileprivate func deleteAllItems() {
        if colors.count != 0 {
            for item in colors {
                model.deleteColor(item)
                colors = [Colors]()
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            if let vc = segue.destination as? CurrentColorViewController {
                let cell = sender as! MemoCell
                let indexPath = tableView.indexPath(for: cell)!
                let color = colors[indexPath.row]
                vc.colorItem = color
                vc.color = UIColor(red: colors[indexPath.row].red as! CGFloat,
                                   green: colors[indexPath.row].green as! CGFloat,
                                   blue: colors[indexPath.row].blue as! CGFloat,
                                   alpha: colors[indexPath.row].alpha as! CGFloat)
            }
        }
    }

}
