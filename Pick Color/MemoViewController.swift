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
    fileprivate var nothingLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colors = model.fetchColors()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        setLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if colors.count == 0 { showLabel() }
        else { hideLabel() }
        return colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemoCell

        cell.colorName.text = colors[indexPath.row].title ?? "Color"
        cell.colorLabel.backgroundColor = colors[indexPath.row].uiColor

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

        dialog.title = titleOfClearColorsString
        dialog.message = messageOfClearColorsString
        dialog.setPositiveButton(withTitle: deleteString, target: self, action: #selector(self.deleteAllItems))
        dialog.setNegativeButton(withTitle: negativeButtonString)

        dialog.show()
    }

    @objc fileprivate func deleteAllItems() {
        for item in colors {
            model.deleteColor(item)
            colors = [Colors]()
            tableView.reloadData()
        }
    }
    
    // MARK: Show or hide label of "Nothing here~"
    
    fileprivate func setLabel() {
        nothingLabel.text = messageOfNothingLabelString
        nothingLabel.textColor = UIColor(rgb: 0x29b6f6)
        nothingLabel.font = UIFont(name: "Avenir", size: 32.0)
        nothingLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingLabel.textAlignment = .center

        self.view.addSubview(nothingLabel)
        
        let midXCon = NSLayoutConstraint(item: nothingLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let midYCon = NSLayoutConstraint(item: nothingLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.view.addConstraint(midXCon)
        self.view.addConstraint(midYCon)
    }

    fileprivate func showLabel() {
        nothingLabel.isHidden = false
        self.view.bringSubview(toFront: nothingLabel)
    }
    
    fileprivate func hideLabel() {
        nothingLabel.isHidden = true
        self.view.sendSubview(toBack: nothingLabel)
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
                vc.color = color.uiColor
            }
        }
    }

}
