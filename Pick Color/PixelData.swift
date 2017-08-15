//
//  PixelData.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 23/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

class PixelData {
    
    fileprivate var data: UnsafePointer<UInt8>!
    fileprivate var context: CGContext?
    
    var image: CGImage? {
        didSet {
            if let image = self.image {
                context = createBitmapContext(image)
                let pixelData = context!.data?.assumingMemoryBound(to: UInt8.self)
                self.data = UnsafePointer<UInt8>(pixelData)
            } else {
                self.data = nil
            }
        }
    }
    
    fileprivate func createBitmapContext(_ image: CGImage) -> CGContext {
        let width = image.width
        let height = image.height

        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(height)
        let bitmapData = malloc(bitmapByteCount)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let bitsPerComp = image.bitsPerComponent
        
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: bitsPerComp, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(image, in: rect)
        
        return context!
    }
    
    func getPartOfImage(x: Int, y: Int) -> UIImage? {
        if let imageWidth = image?.width {
            let imageHight = image!.height
            if x >= 0 && x < imageWidth && y >= 0 && y < imageHight {
                let rect: CGRect = CGRect(x: x - 10, y: y - 10, width: 20, height: 20)
                if let imageRef = self.image!.cropping(to: rect) {
                    let image: UIImage = UIImage(cgImage: imageRef)
                    return image
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    
    func pixelColorAt(x: Int, y: Int) -> UIColor? {
        if let imageWidth = image?.width {
            let imageHight = image!.height
            if x >= 0 && x < imageWidth && y >= 0 && y < imageHight {
                let pixelInfo = 4 * (imageWidth * y + x)
                let a = CGFloat(data[pixelInfo]) / 255
                let r = CGFloat(data[pixelInfo + 1]) / 255
                let g = CGFloat(data[pixelInfo + 2]) / 255
                let b = CGFloat(data[pixelInfo + 3]) / 255
                
                let color = UIColor(red: r, green: g, blue: b, alpha: a)
                
                return color
            }
        }
        
        return nil
    }
}
