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
    
    fileprivate var imagePoint: CGPoint!
    fileprivate var originPoint: CGPoint?
    var delegate: PickerViewDelegation?

    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let point = touches.first?.location(in: self) {
            let percentX = point.x / self.frame.size.width;
            let percentY = point.y / self.frame.size.height;
            
            imagePoint = CGPoint(x: self.image!.size.width * percentX, y: self.image!.size.height * percentY);
        
            if delegate != nil  {
                delegate?.theTouchingLocation(imagePoint)
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
                
                if delegate != nil  {
                    delegate?.theTouchingLocation(imagePoint)
                }
            }
        }
    }
}
