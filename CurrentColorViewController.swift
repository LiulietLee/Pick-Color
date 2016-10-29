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
        let r = view.bounds.size.width * 0.25
        colorLabel.layer.cornerRadius = r
        colorLabel.layer.masksToBounds = true
        constraintOfColorSlider.constant += view.frame.width
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        view.addGestureRecognizer(pan)
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

    // TODO: Add `UIColor(displayP3Red:green:blue:alpha:)` and `#colorLiteral(red:green:blue:alpha)`
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
        default:
            codeLabel1.text = "Color.FromArgb(\(colorValues[3]),  "
            codeLabel2.text = "\(colorValues[0]), "
            codeLabel3.text = "\(colorValues[1]), "
            codeLabel4.text = "\(colorValues[2]));"
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
            withTitle: "Copyed (｀・ω・´)",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "Done",
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
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.isCodeLabelHidden = true
        })
    }
    
    fileprivate func hideEditing(duration: Double) {
        constrainOfCodeLabel.constant = 0
        constraintOfColorSlider.constant = view.frame.width
        isCodeLabelHidden = false
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            isCodeLabelHidden = false
            let translation = sender.translation(in: view).x
            constrainOfCodeLabel.constant += translation
            constraintOfColorSlider.constant += translation
            sender.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            if constrainOfCodeLabel.constant < -view.frame.width / 2 {
                showEditing(duration: 0.3)
            } else {
                hideEditing(duration: 0.3)
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "save" {
            if let vc = segue.destination as? SaveViewController {
                vc.color = colorLabel.backgroundColor
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
