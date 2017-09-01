//
//  CurrentColorViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 10/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class CurrentColorViewController: UIViewController, UIPopoverPresentationControllerDelegate, SaveViewControllerDelegate {

    @IBOutlet weak var panView: UIView!
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
                title = item.title
                saveBarButton.image = UIImage(named: "ic_bookmark.jpg")
            } else {
                title = ""
                saveBarButton.image = UIImage(named: "ic_bookmark_border.jpg")
            }
        }
    }
    
    fileprivate var colorValues = [CGFloat](repeating: 0.0, count: 4) {
        didSet {
            redSlider.value = Float(colorValues[0])
            greenSlider.value = Float(colorValues[1])
            blueSlider.value = Float(colorValues[2])
            alphaSlider.value = Float(colorValues[3])
            
            redColorValueLabel.text = String(describing: colorValues[0])
            greenColorValueLabel.text = String(describing: colorValues[1])
            blueColorValueLabel.text = String(describing: colorValues[2])
            alphaValueLabel.text = String(describing: colorValues[3])
            
            if #available(iOS 10.0, *) {
                colorLabel.backgroundColor = UIColor(displayP3Red: colorValues[0],
                                                     green: colorValues[1],
                                                     blue: colorValues[2],
                                                     alpha: colorValues[3])
            } else {
                colorLabel.backgroundColor = UIColor(red: colorValues[0],
                                                     green: colorValues[1],
                                                     blue: colorValues[2],
                                                     alpha: colorValues[3])
            }
            
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
        let r = view.bounds.size.width * 0.25
        colorLabel.layer.cornerRadius = r
        colorLabel.layer.masksToBounds = true
        constraintOfColorSlider.constant += view.frame.width
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        panView.addGestureRecognizer(pan)
    }
    
    fileprivate func getColorValue() {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if color!.getRed(&r, green: &g, blue: &b, alpha: &a) {
            colorValues[0] = max(min(round(r * 1000) / 1000, 1.0), 0.0)
            colorValues[1] = max(min(round(g * 1000) / 1000, 1.0), 0.0)
            colorValues[2] = max(min(round(b * 1000) / 1000, 1.0), 0.0)
            colorValues[3] = max(min(round(a * 1000) / 1000, 1.0), 0.0)
        }
    }

    fileprivate func writeCode(_ language: Int8) {
        switch language {
        case 0:
            codeLabel1.text = "UIColor(red: \(colorValues[0]), "
            codeLabel2.text = "green: \(colorValues[1]), "
            codeLabel3.text = "blue: \(colorValues[2]), "
            codeLabel4.text = "alpha: \(colorValues[3]))"
        case 1:
            codeLabel1.text = "[UIColor colorWithRed:\(colorValues[0]) "
            codeLabel2.text = "green:\(colorValues[1]) "
            codeLabel3.text = "blue:\(colorValues[2]) "
            codeLabel4.text = "alpha:\(colorValues[3])];"
        case 2:
            codeLabel1.text = "Color.FromArgb(\(colorValues[3]),  "
            codeLabel2.text = "\(colorValues[0]), "
            codeLabel3.text = "\(colorValues[1]), "
            codeLabel4.text = "\(colorValues[2]));"
        case 3:
            codeLabel1.text = "new Color(\(Int(colorValues[0] * 255)), "
            codeLabel2.text = "\(Int(colorValues[1] * 255)), "
            codeLabel3.text = "\(Int(colorValues[2] * 255)), "
            codeLabel4.text = "\(Int(colorValues[3] * 255)));"
        default:
            codeLabel1.text = "rgba(\(Int(colorValues[0] * 255)), "
            codeLabel2.text = "\(Int(colorValues[1] * 255)), "
            codeLabel3.text = "\(Int(colorValues[2] * 255)), "
            codeLabel4.text = "\(colorValues[3]));"
        }
    }

    private var isCodeLabelHidden: Bool {
        get {
            return codeLabel1.isHidden
        }
        set {
            codeLabel1.isHidden = newValue
            codeLabel2.isHidden = newValue
            codeLabel3.isHidden = newValue
            codeLabel4.isHidden = newValue
        }
    }

    fileprivate func saveEditedColor() {
        if let colorItem = colorItem {
            colorItem.updateColor(fromComponents: colorValues)
            model.saveEditedColor()
        }
    }
    
    @IBAction func copyButtonTapped() {
        let string = "\(codeLabel1.text!)\(codeLabel2.text!)\(codeLabel3.text!)\(codeLabel4.text!)"
        UIPasteboard.general.string = string
        
        let snackbar = MKSnackbar (
            withTitle: titleOfSnackbarString,
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: doneString,
            withActionButtonColor: UIColor.MKColor.Blue.A100
        )
        snackbar.show()
    }

    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        writeCode(Int8(sender.selectedSegmentIndex))
    }

    @IBAction func colorChanged(_ sender: UISlider) {
        colorValues[sender.tag] = round(CGFloat(sender.value) * 1000) / 1000
        saveEditedColor()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if constrainOfCodeLabel.constant == 0 {
            showEditing(duration: 0.618)
        } else {
            hideEditing(duration: 0.618)
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
    
    fileprivate func showEditing(duration: Double) {
        constrainOfCodeLabel.constant = -view.frame.width
        constraintOfColorSlider.constant = -15
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: { 
            self.view.layoutIfNeeded()
        }) { finish in
            if finish {
                self.isCodeLabelHidden = true
            }
        }
    }
    
    fileprivate func hideEditing(duration: Double) {
        constrainOfCodeLabel.constant = 0
        constraintOfColorSlider.constant = view.frame.width
        isCodeLabelHidden = false
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let translation = sender.translation(in: view).x
            isCodeLabelHidden = false
            constrainOfCodeLabel.constant += translation
            constraintOfColorSlider.constant += translation
            sender.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            let velocity = sender.velocity(in: view).x
            if velocity < 0 {
                showEditing(duration: 0.3)
            } else {
                hideEditing(duration: 0.3)
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            if let vc = segue.destination as? SaveViewController {
                vc.color = color!                
                vc.delegate = self
                vc.item = colorItem
                if let controller = vc.popoverPresentationController {
                    controller.delegate = self
                }
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
