//
//  UIView+ZL.swift
//  FBSnapshotTestCase
//
//  Created by SJYY on 2018/11/9.
//

import Foundation
import SnapKit

private var gradualLayerKey = Date().timeIntervalSince1970 + 200

@objc public extension UIView {
    
    /// 渐变色的layer 可以用来测试渐变色
    @objc public var zl_gradualLayer:CAGradientLayer{
        set{
            if   layer.sublayers?.contains(newValue) ?? true {
            }else {
                 zl_gradualLayer.removeFromSuperlayer()
                layer.addSublayer(newValue)
            }
            zl_gradualLayer.frame = self.bounds
            objc_setAssociatedObject(self, &gradualLayerKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            if let gradL = objc_getAssociatedObject(self, &gradualLayerKey) as? CAGradientLayer{
                return gradL
            }
            let gradL = CAGradientLayer()
            gradL.frame = self.bounds
            layer.addSublayer(gradL)
            objc_setAssociatedObject(self, &gradualLayerKey, gradL, .OBJC_ASSOCIATION_ASSIGN)
            return gradL
        }
    }
    
    
    
}


// MARK: - 四周边框
public extension UIView{
    public var ZLTextFieldBottomLineTag:Int{
        return 10002
    }
    public var ZLTextFieldLeftLineTag:Int{
        return 10003
    }
    public var ZLTextFieldRightLineTag:Int{
        return 10004
    }
    public var ZLTextFieldTopLineTag:Int{
        return 10005
    }
    @objc public var bottomLineV:ZLView{
        if let view = self.viewWithTag(ZLTextFieldBottomLineTag) as? ZLView{
            return view
        }
        let view = ZLView.init(frame: CGRect.init())
        view.zl_intrisizeHeight = 0.5
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-0.5)
        }
        view.tag = ZLTextFieldBottomLineTag
        return view
    }
    @objc public var zl_leftLineV:ZLView{
        if let view = self.viewWithTag(ZLTextFieldLeftLineTag) as? ZLView{
            return view
        }
        let view = ZLView.init(frame: CGRect.init())
        view.zl_intrisizeHeight = 0.5
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(0.5)
        }
        view.tag = ZLTextFieldLeftLineTag
        return view
    }
    @objc public var zl_rightLineV:ZLView{
        if let view = self.viewWithTag(ZLTextFieldRightLineTag) as? ZLView{
            return view
        }
        let view = ZLView.init(frame: CGRect.init())
        view.zl_intrisizeHeight = 0.5
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(0.5)
        }
        view.tag = ZLTextFieldRightLineTag
        return view
    }
    @objc public var zl_topLineV:ZLView{
        if let view = self.viewWithTag(ZLTextFieldTopLineTag) as? ZLView{
            return view
        }
        let view = ZLView.init(frame: CGRect.init())
        view.zl_intrisizeHeight = 0.5
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(0.5)
        }
        view.tag = ZLTextFieldTopLineTag
        return view
    }
}



@objc public extension UIView{
    @objc public func zl_cornerRadius(_ radio:CGFloat,color:UIColor = UIColor.gray){
        self.layer.cornerRadius  =  radio
        self.layer.masksToBounds = true
    }
    @objc public func zl_border(width:CGFloat = 0.5,color:UIColor = UIColor.zl_hexColor(hex: 0xcccccc)){
        self.layer.borderColor  =  color.cgColor
        self.layer.borderWidth = width
    }
    
}


