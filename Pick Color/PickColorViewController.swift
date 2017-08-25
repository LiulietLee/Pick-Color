//
//  PickColorViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 23/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class PickColorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PickerViewDelegate {

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
    fileprivate var pan: UIPanGestureRecognizer? = nil
    fileprivate var image: UIImage? {
        didSet {
            if let rawIamge = image {
                if (pan != nil) {
                    view.removeGestureRecognizer(pan!)
                }
                
                if rawIamge.imageOrientation == .up {
                    image = rawIamge
                } else {
                    UIGraphicsBeginImageContextWithOptions(rawIamge.size, false, rawIamge.scale)
                    defer { UIGraphicsEndImageContext() }
                    rawIamge.draw(in: CGRect(origin: .zero, size: rawIamge.size))
                    image = UIGraphicsGetImageFromCurrentImageContext()
                }
                
                view.sendSubview(toBack: selectImageButton)
                selectImageButton.isHidden = true
                imageView.image = image
                pixelData.image = image!.cgImage
                imageView.model = pixelData
                let scale = view.frame.height / image!.size.height
                heightOfImageView.constant = image!.size.height * scale
                widthOfImageView.constant = image!.size.width * scale
                centerXOfImageView.constant = 0
                centerYOfImageView.constant = 0
                updateManager()
                self.view.backgroundColor = .black
            } else {
                if pan == nil {
                    pan = revealViewController().panGestureRecognizer()
                }
                view.addGestureRecognizer(pan!)
                view.bringSubview(toFront: self.selectImageButton)
                pickColorButton.isEnabled = false
            }
        }
    }
    
    fileprivate var color: UIColor? {
        willSet {
            if let newColor = newValue {
                pickColorButton.setTitleColor(newColor, for: UIControlState())
            }
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        if pan == nil {
            pan = revealViewController().panGestureRecognizer()
        }
        view.addGestureRecognizer(pan!)

        imagePicker.delegate = self
        imageView.delegate = self
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleUpOrDownTheImageView(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveImage(_:)))
        panGesture.minimumNumberOfTouches = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.resetImage(_:)))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        
        let r = view.bounds.size.width * 0.375
        selectImageButton.layer.masksToBounds = true
        selectImageButton.layer.cornerRadius = r
        
        if let view = manager.imageView {
            image = view.image
        }
        
        if !isAppAlreadyLaunchedOnce() {
            firstLaunch()
        }
    }

    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }

    func firstLaunch() {
        let dialog = LLDialog()
        dialog.title = "Hint"
        dialog.message = "This app selects pixel of screenshot and saved image."
        dialog.setPositiveButton(withTitle: "I see", target: nil, action: nil)
        dialog.show()
    }

    // MARK: Delegation
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
        } else { print("pick image failed") }
        self.dismiss(animated: true, completion: nil)
    }
    
    func theTouchingLocation(_ location: CGPoint) {
        color = pixelData.pixelColorAt(x: Int(location.x), y: Int(location.y))
        pickColorButton.isEnabled = true
    }

    // MARK: Button actions
    
    @IBAction func selectImageButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func pickColorButtonTapped() {}
    
    // MARK: Private functions
    
    fileprivate func updateManager() {
        manager.imageView = imageView
    }
    
    @objc fileprivate func moveImage(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let translate = sender.translation(in: view)
            centerXOfImageView.constant += translate.x
            centerYOfImageView.constant += translate.y
            sender.setTranslation(.zero, in: view)
            updateManager()
        default: break
        }
    }
    
    @objc fileprivate func scaleUpOrDownTheImageView(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let scale = sender.scale
            widthOfImageView.constant *= scale
            heightOfImageView.constant *= scale
            centerXOfImageView.constant *= scale
            centerYOfImageView.constant *= scale
            sender.scale = 1.0
            updateManager()
        default:
            break
        }
    }
    
    @objc fileprivate func resetImage(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let image = self.image {
                let scale = view.frame.height / image.size.height
                heightOfImageView.constant = image.size.height * scale
                widthOfImageView.constant = image.size.width * scale
                centerXOfImageView.constant = 0
                centerYOfImageView.constant = 0
                updateManager()
                UIView.animate(withDuration: 0.618, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showColor":
            let vc = segue.destination as! CurrentColorViewController
            vc.color = pickColorButton.titleColor(for: .normal)
        default:
            break
        }
    }

}
