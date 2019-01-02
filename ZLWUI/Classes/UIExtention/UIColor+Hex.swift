//
//  UIColor.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//

import Foundation

@objc public extension UIColor{
    
}

//
//
//  Created by zhilong on 2018/9/3.
//  Copyright © 2018年 SJYY. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UIColor 16位颜色的计算
@objc public extension UIColor{
    class func zl_hexColor(hex:Int32,alpha:CGFloat = 1) -> UIColor{
        return  UIColor.init(red:  CGFloat((hex & 0xFF0000 ) >> 16 )/255.0, green: CGFloat((hex & 0x00FF00 ) >> 8 )/255.0, blue: CGFloat((hex & 0x0000FF )  )/255.0, alpha: alpha)
    }
    class func zl_hexColor(red: CGFloat, green: CGFloat, blue: CGFloat ,alpha:CGFloat = 1) -> UIColor{
        return UIColor.init(red: red/255.0, green: red/255.0, blue: blue/255.0, alpha:alpha)
    }
}

// MARK: - CIImage  生成高清的UIImage
public extension CIImage{
    //MARK: - 生成高清的UIImage
    func zl_HighDefinitionUIImage(_ size: CGFloat) -> UIImage {
        let integral: CGRect = self.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(self, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
}

