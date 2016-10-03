//
//  SaveViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 15/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

protocol SaveViewControllerDelegation {
    func colorSaved(color: Colors)
    func colorDeleted()
    func colorEdited(color: Colors)
}

class SaveViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: SaveViewControllerDelegation?
    var color: UIColor!
    var item: Colors?
    fileprivate var model = CoreDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            cancelButton.setTitle("delete", for: .normal)
            cancelButton.setTitleColor(UIColor.red, for: .normal)
            textField.text = item!.title
        }
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped() {
        if item != nil {
            model.deleteColor(item!)
            if delegate != nil {
                delegate?.colorDeleted()
            }
        }
        goBack()
    }

    @IBAction func saveButtonTapped() {
        if let title = textField.text {
            if item == nil {
                let colorItem = model.saveNewColor(newColor: color, title: title)
                if delegate != nil {
                    delegate?.colorSaved(color: colorItem)
                }
            } else {
                item!.title = title
                model.saveEditedColor()
                if delegate != nil {
                    delegate?.colorEdited(color: item!)
                }
            }
        }
        
        goBack()
    }
    
    fileprivate func goBack() {
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
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
