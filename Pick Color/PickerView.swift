//
//  PickerView.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 3/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

protocol PickerViewDelegation {
    func theTouchingLocation(_ location: CGPoint)
}

class PickerView: UIImageView {
    
    fileprivate var selectView = SelectImageView()
    fileprivate var imagePoint: CGPoint?
    fileprivate var clipedImage = UIImage() {
        didSet {
            selectView.image = clipedImage
        }
    }
    
    var delegate: PickerViewDelegation?
    var model: PixelData!
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        
        selectView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        selectView.radius = 50
        selectView.alpha = 0.0
        self.addSubview(selectView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let point = touches.first?.location(in: self) {
            let percentX = point.x / self.frame.size.width;
            let percentY = point.y / self.frame.size.height;
            
            imagePoint = CGPoint(x: self.image!.size.width * percentX, y: self.image!.size.height * percentY)
        
            selectView.alpha = 1.0
            selectView.frame = CGRect(origin: CGPoint(x: point.x - 50, y: point.y - 120),
                                      size: CGSize(width: 100, height: 100))
            if let image = model.getPartOfImage(x: imagePoint!.x, y: imagePoint!.y) {
                clipedImage = image
            }

            if delegate != nil {
                delegate?.theTouchingLocation(imagePoint!)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let point = touches.first?.location(in: self) {
            if touches.count <= 1 {
                let percentX = point.x / self.frame.size.width;
                let percentY = point.y / self.frame.size.height;
                
                imagePoint = CGPoint(x: self.image!.size.width * percentX, y: self.image!.size.height * percentY)

                selectView.alpha = 1.0
                selectView.frame = CGRect(origin: CGPoint(x: point.x - 50, y: point.y - 120),
                                          size: CGSize(width: 100, height: 100))
                if let image = model.getPartOfImage(x: imagePoint!.x, y: imagePoint!.y) {
                    clipedImage = image
                }
                
                if delegate != nil  {
                    delegate?.theTouchingLocation(imagePoint!)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selectView.alpha = 0.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        selectView.alpha = 0.0
    }
}
