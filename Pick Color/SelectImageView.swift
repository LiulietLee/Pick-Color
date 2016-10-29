//
//  SelectImageView.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 3/10/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class SelectImageView: UIView {

    fileprivate var imageView = UIImageView()
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var radius: CGFloat = 15
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        imageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        addSubview(imageView)
        let overImageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        overImageView.image = UIImage(named: "search.png")
        addSubview(overImageView)
    }

}
