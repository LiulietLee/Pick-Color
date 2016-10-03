//
//  PickColorViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 23/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class PickColorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PickerViewDelegation {

    // MARK: Properties
    
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageView: PickerView!
    
    @IBOutlet weak var centerYOfImageView: NSLayoutConstraint!
    @IBOutlet weak var centerXOfImageView: NSLayoutConstraint!
    @IBOutlet weak var widthOfImageView: NSLayoutConstraint!
    @IBOutlet weak var heightOfImageView: NSLayoutConstraint!
    
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var pixelData = PixelData()

    fileprivate var image: UIImage? {
        didSet {
            if image != nil {
                self.view.sendSubview(toBack: self.selectImageButton)
                selectImageButton.isHidden = true
                imageView.image = image!
                pixelData.image = image!
                let scale = self.view.frame.height / image!.size.height
                heightOfImageView.constant = image!.size.height * scale
                widthOfImageView.constant = image!.size.width * scale
            } else {
                self.view.bringSubview(toFront: self.selectImageButton)
                pickColorButton.isEnabled = false
            }
        }
    }
    
    fileprivate var color: UIColor? {
        didSet {
            drawCircle(self.color)
            pickColorButton.setTitleColor(self.color, for: UIControlState())
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        imagePicker.delegate = self
        imageView.delegate = self
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleUpOrDownTheImageView(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveImage(_:)))
        panGesture.minimumNumberOfTouches = 2
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(panGesture)
        
        let r = self.view.bounds.size.width * 0.4444
        selectImageButton.layer.masksToBounds = true
        selectImageButton.layer.cornerRadius = r
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Delegation
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func theTouchingLocation(_ location: CGPoint) {
        self.color = pixelData.getPixelColorOfPoint(x: location.x, y: location.y)
        if !pickColorButton.isEnabled {
            pickColorButton.isEnabled = true
        }
    }
    
    // MARK: Button actions
    
    @IBAction func selectImageButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func pickColorButtonTapped() {}
    
    // MARK: Private functions
    
    @objc fileprivate func drawCircle(_ color: UIColor?) {
        if color != nil {
            
        } else {
            
        }
    }
    
    @objc fileprivate func moveImage(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began: fallthrough
        case .changed:
            let translate = sender.translation(in: self.view)
            centerXOfImageView.constant += translate.x
            centerYOfImageView.constant += translate.y
            sender.setTranslation(CGPoint.zero, in: self.view)
        default: break
        }
    }
    
    @objc fileprivate func scaleUpOrDownTheImageView(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began: fallthrough
        case .changed:
            let scale = sender.scale
            widthOfImageView.constant *= scale
            heightOfImageView.constant *= scale
            sender.scale = 1.0
        default:
            break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showColor":
            let vc = segue.destination as! CurrentColorViewController
            vc.color = color
        default:
            break
        }
    }

}
