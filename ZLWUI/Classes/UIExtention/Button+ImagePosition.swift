//
//  Button+ImagePosition.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//

import Foundation

@objc open class ZLButton:UIButton{
    /// 设置返回的intri
    @objc public var zl_intrisizeHeight:CGFloat = 0
    /// intrisize 的宽度
    @objc public var zl_intrisizeWidth:CGFloat = 0
    
    open override var intrinsicContentSize: CGSize{
        let h = zl_intrisizeHeight != 0 ? zl_intrisizeHeight : super.intrinsicContentSize.height
        let w = zl_intrisizeWidth != 0 ? zl_intrisizeWidth : super.intrinsicContentSize.width
        return CGSize.init(width: w, height: h)
    }
    /// type 0 img上方
    @objc public func zl_imgAt(type:String, spacing:CGFloat = 0)->Void{
        guard let label = self.titleLabel,let imgv = self.imageView else {
            return
        }
        let imageWidth = imgv.image?.size.width ?? 0
        let imageHeight = imgv.image?.size.height ?? 0
        let titleSize = NSString.init(string: label.text ?? "").size(withAttributes: [ NSAttributedStringKey.font:self.titleLabel!.font])
        
        let labelHeight = titleSize.height
        let labelWidth = titleSize.width
        
        //image中心移动的x距离
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
        let imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
        
        
        let tempWidth = max(labelWidth, imageWidth);
        let changedWidth = labelWidth + imageWidth - tempWidth;
        let tempHeight = max(labelHeight, imageHeight);
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight;
        
        if type == "l"{
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
        }
        if type == "r"{
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
        }
        if type == "t"{
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
        }
        if type == "b"{
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
        }
     
        
    }
   
}





// MARK: - 图片位置
@objc public extension UIButton{
    @objc public func zl_imgAtLeft()->Void{
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -1 * (self.imageView?.image?.size.width ?? 0), bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -1 * (self.titleLabel?.intrinsicContentSize.width ?? 0) , bottom: 0, right: 0)
    }
    
}


public extension UIButton{
    public convenience init(config:ButtonConfig) {
        self.init(frame: CGRect.init())
    }
    public func zl_configButton(_ btnConfig:ButtonConfig?){
        guard let   config = btnConfig else {return}
        switch config {
        case .title(let normal, let height, let disable):
            self.setTitle(normal, for: .normal)
            self.setTitle(height, for: .highlighted)
            self.setTitle(disable, for: .disabled)
        case .image(let normal, let height, let disable):
            self.setImage(normal, for: .normal)
            self.setImage(height, for: .highlighted)
            self.setImage(disable, for: .disabled)
        case .backGroundImg(let normal, let height, let disable):
            self.setBackgroundImage(normal, for: .normal)
            self.setBackgroundImage(height, for: .highlighted)
            self.setBackgroundImage(disable, for: .disabled)
        case .titleColor(let normal, let height, let disable):
            setTitleColor(normal, for: .normal)
            setTitleColor(height, for: .highlighted)
            setTitleColor(disable, for: .disabled)
        case .more(let configs):
            configs.forEach { [weak self](c) in
                self?.zl_configButton( c)
            }
        }
        
    }
}

public enum ButtonConfig{
    case title(String?,String?,String?)
    case backGroundImg(UIImage?,UIImage?,UIImage?)
    case image(UIImage?,UIImage?,UIImage?)
    case titleColor(UIColor?,UIColor?,UIColor?)
    case more([ButtonConfig])
}


