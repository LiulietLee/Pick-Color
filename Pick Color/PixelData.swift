//
//  PixelData.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 23/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit

protocol PixelDataDelegate {
    func gotPixelData(_ color: UIColor)
}

class PixelData {
    
    fileprivate var data: UnsafePointer<UInt8>? = nil
    
    var delegate: PixelDataDelegate?
    var image: UIImage? {
        didSet {
            if let image = self.image {
                let cgimage = image.cgImage
                let context = createBitmapContext(cgimage!)
                let pixelData = context.data?.assumingMemoryBound(to: UInt8.self)
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
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(image, in: rect)
        
        return context!
    }
    
    func getPartOfImage(x: CGFloat, y: CGFloat) -> UIImage? {
        if let imageWidth = image?.size.width {
            let imageHight = image!.size.height
            if x >= 0 && x < imageWidth && y >= 0 && y < imageHight {
                let rect: CGRect = CGRect(x: x - 10, y: y - 10, width: 20, height: 20)
                let imageRef = self.image!.cgImage!.cropping(to: rect)
                let image: UIImage = UIImage(cgImage: imageRef!)
                return image
            }
        }
        return nil
    }
    
    func getPixelColorOfPoint(x: CGFloat, y: CGFloat) -> UIColor? {
        if let imageWidth = image?.size.width {
            let imageHight = image!.size.height
            if x >= 0 && x < imageWidth && y >= 0 && y < imageHight {
                let pixelInfo = 4 * ((Int(imageWidth) * Int(y)) + Int(x))
                let a: CGFloat = CGFloat(data![pixelInfo]) / 255
                let r: CGFloat = CGFloat(data![pixelInfo + 1]) / 255
                let g: CGFloat = CGFloat(data![pixelInfo + 2]) / 255
                let b: CGFloat = CGFloat(data![pixelInfo + 3]) / 255
                
                let color = UIColor(red: r, green: g, blue: b, alpha: a)
                
                if delegate != nil {
                    delegate?.gotPixelData(color)
                }
                
                return color
            }
        }
        
        return nil
    }
}
