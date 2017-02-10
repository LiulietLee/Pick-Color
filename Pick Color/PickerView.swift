//
//  PickerView.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 3/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

protocol PickerViewDelegate: class {
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
    
    weak var delegate: PickerViewDelegate?
    var model: PixelData!
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
        
        selectView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        selectView.radius = 50
        selectView.alpha = 0.0
        addSubview(selectView)
    }

    private func update(forTouches touches: Set<UITouch>) {
        if let point = touches.first?.location(in: self) {
            let percentX = point.x / frame.size.width;
            let percentY = point.y / frame.size.height;

            imagePoint = CGPoint(x: image!.size.width * percentX, y: image!.size.height * percentY)

            selectView.alpha = 1.0
            selectView.frame = CGRect(x: point.x - 50, y: point.y - 120, width: 100, height: 100)
            if let image = model.getPartOfImage(x: Int(imagePoint!.x), y: Int(imagePoint!.y)) {
                clipedImage = image
            }

            delegate?.theTouchingLocation(imagePoint!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        update(forTouches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        update(forTouches: touches)
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
