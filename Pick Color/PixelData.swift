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
    fileprivate var context: CGContext!
    
    var image: CGImage? {
        didSet {
            if let image = image {
                context = createBitmapContext(image)
                let pixelData = context.data!.assumingMemoryBound(to: UInt8.self)
                self.data = UnsafePointer<UInt8>(pixelData)
            } else {
                self.data = nil
            }
        }
    }
    
    fileprivate func createBitmapContext(_ image: CGImage) -> CGContext {
        let width = image.width
        let height = image.height
        
        // TODO: Support Display P3
        let bitsPerComp = 8 // image.bitsPerComponent
        let bitmapBytesPerRow = width * 4 // * (bitsPerComp / 8)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        let size = CGSize(width: width, height: height)
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: bitsPerComp, bytesPerRow: bitmapBytesPerRow,
            space: colorSpace, bitmapInfo: bitmapInfo)!
        
        let rect = CGRect(origin: .zero, size: size)
        context.draw(image, in: rect)
        
        return context
    }
    
    func getPartOfImage(x: Int, y: Int) -> UIImage? {
        guard let image = image else { return nil }
        let imageWidth = image.width
        let imageHight = image.height
        var rect: CGRect { // lazy initialized
            return CGRect(x: x - 10, y: y - 10, width: 20, height: 20)
        }
        guard x >= 0 && x < imageWidth && y >= 0 && y < imageHight
            , let imageRef = image.cropping(to: rect)
            else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    func pixelColorAt(x: Int, y: Int) -> UIColor? {
        guard let image = image, let data = data else { return nil }
        let imageWidth = image.width
        let imageHight = image.height
        if x >= 0 && x < imageWidth && y >= 0 && y < imageHight {
            let pixelInfo = 4 * (imageWidth * y + x)
            let r = CGFloat(data[pixelInfo + 0]) / 255
            let g = CGFloat(data[pixelInfo + 1]) / 255
            let b = CGFloat(data[pixelInfo + 2]) / 255
            let a = CGFloat(data[pixelInfo + 3]) / 255
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        return nil
    }
}
