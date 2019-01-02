//
//  UIImage+color.swift
//  FBSnapshotTestCase
//
//  Created by SJYY on 2018/11/9.
//

import Foundation
import Accelerate
@objc public extension UIImage{
   
    @objc public class func from(color:UIColor,size:CGSize = CGSize.init(width: 3, height: 64)) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        let content = UIGraphicsGetCurrentContext()
        content?.setFillColor(color.cgColor)
        content?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        return img
    }
    
    
    //MARK: --生成二维码
    
    /// 根据字符串和头像图片生成二维码
    @objc public class func QrCodeImg(_ text:String,icon:UIImage? = nil) -> UIImage?{
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = outputImage.setupHighDefinitionUIImage( 300)
            
            //如果有一个头像的话，将头像加入二维码中心
            if let image = icon {
                return SyntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
            }
            return qrCodeImage
        }
        return nil
    }
    /// image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    class func SyntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    class func boxBlurImage(image: UIImage, withBlurNumber blur: CGFloat) -> UIImage {
        var blur = blur
        if blur < 0.0  {
            blur = 0
        }
        if blur > 1{
            blur = 1
        }
        var boxSize = Int(blur * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        guard  let img = image.cgImage else{
            return image
        }
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutableRawPointer
        
        // 从CGImage中获取数据
        let inProvider = img.dataProvider // CGImageGetDataProvider(img)
        let inBitmapData = inProvider?.data// CGDataProviderCopyData(inProvider!)
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = vImagePixelCount(img.width)//UInt(CGImageGetWidth(img))
        inBuffer.height = vImagePixelCount(img.height)//UInt(CGImageGetHeight(img))
        inBuffer.rowBytes = img.bytesPerRow// CGImageGetBytesPerRow(img)
        
        inBuffer.data =  UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(img.bytesPerRow * img.width)
        if pixelBuffer == nil {
            NSLog("No pixel buffer!")
        }
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img.width)
        outBuffer.height = UInt(img.height)
        outBuffer.rowBytes = img.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            NSLog("error from convolution %ld", error)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let ctx = CGContext.init(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: img.bitmapInfo.rawValue) else{
            return image
        }
        guard let imageRef = ctx.makeImage() else{
            return image
        }
        let returnImage = UIImage.init(cgImage: imageRef)
        free(pixelBuffer)
        return returnImage
    }
    
}

// MARK: - CIImage  生成高清的UIImage
public extension CIImage{
    //MARK: - 生成高清的UIImage
    func setupHighDefinitionUIImage(_ size: CGFloat) -> UIImage {
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

