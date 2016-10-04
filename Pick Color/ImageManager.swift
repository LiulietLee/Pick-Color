//
//  ImageManager.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 3/10/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

let manager = ImageManager.shared

class ImageManager {
    static let shared = ImageManager()
    private init () {}
    
     var imageView: PickerView?
     var centerYOfImageView: NSLayoutConstraint?
     var centerXOfImageView: NSLayoutConstraint?
     var widthOfImageView: NSLayoutConstraint?
     var heightOfImageView: NSLayoutConstraint?

}
