//
//  InputView.swift
//  MDTokenManage
//
//  Created by zhilong on 2018/9/5.
//  Copyright © 2018年 SJYY. All rights reserved.
//

import UIKit

@objc open  class ZLTF: UITextField  {
    /// 设置返回的intri
    @objc public var zl_intrisizeHeight:CGFloat = 0
    /// intrisize 的宽度
    @objc public var zl_intrisizeWidth:CGFloat = 0
    
    open override var intrinsicContentSize: CGSize{
        let h = zl_intrisizeHeight != 0 ? zl_intrisizeHeight : super.intrinsicContentSize.height
        let w = zl_intrisizeWidth != 0 ? zl_intrisizeWidth : super.intrinsicContentSize.width
        return CGSize.init(width: w, height: h)
    }
}


@objc public extension UITextField{
    @objc public var zl_bottomLine:UIView{
        if let view = self.viewWithTag(101) as? ZLView{
            return view
        }
        let view = ZLView.init(frame: CGRect.init())
        addSubview(view)
//        view.addConstraint(NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -0.5))
//        view.addConstraint(NSLayoutConstraint.init(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint.init(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        view.zl_intrisizeHeight = 0.5
        sendSubview(toBack: view)
        return view
    }
}

@objc public extension UITextField{
    @objc public var leftMargin:CGFloat{
        set{
            let view = self.leftView ?? UIView.init()
            view.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width + newValue, height: self.frame.size.height)
            self.leftView = view
            self.leftViewMode = .always
        }
        get{
            return self.leftView?.frame.size.width ?? 0
        }
    }
}




