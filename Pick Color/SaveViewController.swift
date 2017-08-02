//
//  SaveViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 15/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit
import Foundation

protocol SaveViewControllerDelegate: class {
    func colorSaved(color: Colors)
    func colorDeleted()
    func colorEdited(color: Colors)
}

class SaveViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textField: UITextField!

    weak var delegate: SaveViewControllerDelegate?
    var color: UIColor!
    var item: Colors?
    fileprivate var model = CoreDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            cancelButton.setTitle(deleteString, for: .normal)
            cancelButton.setTitleColor(.red, for: .normal)
            textField.text = item.title
        }
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped() {
        if let item = item {
            model.deleteColor(item)
            delegate?.colorDeleted()
        }
        goBack()
    }

    @IBAction func saveButtonTapped() {
        defer { goBack() }
        guard let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if title != "" {
            if let item = item {
                item.title = title
                model.saveEditedColor()
                delegate?.colorEdited(color: item)
            } else {
                let colorItem = model.saveNewColor(color, title: title)
                delegate?.colorSaved(color: colorItem)
            }
        }
    }

    fileprivate func goBack() {
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

}
