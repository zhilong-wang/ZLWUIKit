//
//  UIFont+AutoSize.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//


import Foundation


// MARK: - UIFont  方法交换，对字体大小进行改变
@objc public extension UIFont{
    @objc class func zl_systemFont(ofSize fontSize: CGFloat) -> UIFont{
        return UIFont.zl_systemFont(ofSize: fontSize * ZLWidthScale)
    }
    @objc public  class func zl_fontScale(){
        let me = class_getClassMethod(UIFont.self, #selector(UIFont.systemFont(ofSize:)))
        let me2 = class_getClassMethod(UIFont.self, #selector(UIFont.zl_systemFont(ofSize:)))
        if let m = me ,let m2 = me2{
            method_exchangeImplementations(m, m2)
        }
    }
}
