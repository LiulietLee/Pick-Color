//
//  CurrentColorViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 10/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class CurrentColorViewController: UIViewController, UIPopoverPresentationControllerDelegate, SaveViewControllerDelegation {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var codeLabel1: UILabel!
    @IBOutlet weak var codeLabel2: UILabel!
    @IBOutlet weak var codeLabel3: UILabel!
    @IBOutlet weak var codeLabel4: UILabel!
    @IBOutlet weak var languageExangeControl: UISegmentedControl!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var redColorValueLabel: UILabel!
    @IBOutlet weak var greenColorValueLabel: UILabel!
    @IBOutlet weak var blueColorValueLabel: UILabel!
    @IBOutlet weak var alphaValueLabel: UILabel!
    
    @IBOutlet weak var constrainOfCodeLabel: NSLayoutConstraint!
    @IBOutlet weak var constraintOfColorSlider: NSLayoutConstraint!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    var color: UIColor?
    fileprivate var model = CoreDataModel()
    
    var colorItem: Colors? {
        didSet {
            if let item = colorItem {
                self.title = item.title
                saveBarButton.image = UIImage(named: "ic_bookmark.jpg")
            } else {
                self.title = ""
                saveBarButton.image = UIImage(named: "ic_bookmark_border.jpg")
            }
        }
    }
    
    fileprivate var colorValues = [CGFloat](repeating: 0.0, count: 4) {
        didSet {
            redSlider.value = Float(colorValues[0]); redColorValueLabel.text = String(describing: colorValues[0])
            greenSlider.value = Float(colorValues[1]); greenColorValueLabel.text = String(describing: colorValues[1])
            blueSlider.value = Float(colorValues[2]); blueColorValueLabel.text = String(describing: colorValues[2])
            alphaSlider.value = Float(colorValues[3]); alphaValueLabel.text = String(describing: colorValues[3])
            
            colorLabel.backgroundColor = UIColor(red: colorValues[0],
                                                 green: colorValues[1],
                                                 blue: colorValues[2],
                                                 alpha: colorValues[3])
            
            writeCode(Int8(languageExangeControl.selectedSegmentIndex))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if color != nil {
            colorLabel.backgroundColor = color
            getColorValue()
            writeCode(0)
        }
        let r = self.view.bounds.size.width * 0.25
        colorLabel.layer.cornerRadius = r
        colorLabel.layer.masksToBounds = true
        constraintOfColorSlider.constant += self.view.frame.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getColorValue() {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if color!.getRed(&r, green: &g, blue: &b, alpha: &a) {
            colorValues[0] = round(r * 1000) / 1000
            colorValues[1] = round(g * 1000) / 1000
            colorValues[2] = round(b * 1000) / 1000
            colorValues[3] = round(a * 1000) / 1000
        }
    }
    
    fileprivate func writeCode(_ language: Int8) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if color!.getRed(&r, green: &g, blue: &b, alpha: &a) {
            if language == 0 {
                codeLabel1.text = "UIColor(red: \(colorValues[0]), "
                codeLabel2.text = "green: \(colorValues[1]), "
                codeLabel3.text = "blue: \(colorValues[2]), "
                codeLabel4.text = "alpha: \(colorValues[3]))"
            } else {
                codeLabel1.text = "[UIColor colorWithRed:\(colorValues[0]) "
                codeLabel2.text = "green:\(colorValues[1]) "
                codeLabel3.text = "blue:\(colorValues[2]) "
                codeLabel4.text = "alpha:\(colorValues[3])];"
            }
        }
    }

    fileprivate func hideCodeLabel(_ bool: Bool) {
        self.codeLabel1.isHidden = bool
        self.codeLabel2.isHidden = bool
        self.codeLabel3.isHidden = bool
        self.codeLabel4.isHidden = bool
    }

    fileprivate func saveEditedColor() {
        if colorItem != nil {
            colorItem!.red = colorValues[0] as NSNumber?
            colorItem!.green = colorValues[1] as NSNumber?
            colorItem!.blue = colorValues[2] as NSNumber?
            colorItem!.alpha = colorValues[3] as NSNumber?
            model.saveEditedColor()
        }
    }
    
    @IBAction func copyButtonTapped() {
        let string = "\(codeLabel1.text!)\(codeLabel2.text!)\(codeLabel3.text!)\(codeLabel4.text!)"
        UIPasteboard.general.string = string
    }

    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        writeCode(Int8(sender.selectedSegmentIndex))
    }
    
    @IBAction func redChanged(_ sender: UISlider) {
        colorValues[0] = round(CGFloat(sender.value) * 1000) / 1000
        saveEditedColor()
    }
    
    @IBAction func greenChanged(_ sender: UISlider) {
        colorValues[1] = round(CGFloat(sender.value) * 1000) / 1000
        saveEditedColor()
    }
    
    @IBAction func blueChanged(_ sender: UISlider) {
        colorValues[2] = round(CGFloat(sender.value) * 1000) / 1000
        saveEditedColor()
    }
    
    @IBAction func alphaChanged(_ sender: UISlider) {
        colorValues[3] = round(CGFloat(sender.value) * 1000) / 1000
        saveEditedColor()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if constrainOfCodeLabel.constant == 0 {
            constrainOfCodeLabel.constant -= self.view.frame.width
            constraintOfColorSlider.constant -= self.view.frame.width + 15
            UIView.animate(withDuration: 0.618, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.hideCodeLabel(true)
            })
        } else {
            constrainOfCodeLabel.constant += self.view.frame.width
            constraintOfColorSlider.constant += self.view.frame.width + 15
            hideCodeLabel(false)
            UIView.animate(withDuration: 0.618) {
                self.view.layoutIfNeeded()
            }
        }
    }
        
    internal func colorSaved(color: Colors) {
        colorItem = color
    }
    
    internal func colorEdited(color: Colors) {
        colorItem = color
    }
    
    internal func colorDeleted() {
        colorItem = nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "save" {
            if let vc = segue.destination as? SaveViewController {
                vc.preferredContentSize = CGSize(width: 360, height: 150)
                vc.color = self.colorLabel.backgroundColor
                vc.delegate = self
                vc.item = colorItem
                let controller = vc.popoverPresentationController
                if controller != nil {
                    controller?.delegate = self
                }
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
