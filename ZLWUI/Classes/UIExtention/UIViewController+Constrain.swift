//
//  UIViewController+Constrain.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//

import Foundation


// MARK: - 安全约束布局
@objc public extension UIViewController{
    
    @objc public var zl_safeMargin:UIEdgeInsets{
        if #available(iOS 11.0, *) {
            
            var area = UIApplication.shared.keyWindow!.safeAreaInsets
            if area.top == 0{
                area = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
            }
            return area
        } else {
            return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
    @objc public var zl_safeAreaLayoutGuard:UILayoutGuide{
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            let arr = self.view.layoutGuides.filter{$0.identifier == "zl_safeAreaLayoutGuard"}
            if let layoutGuide = arr.first{
                return layoutGuide
            }
            let layoutGuide = UILayoutGuide.init()
            layoutGuide.identifier = "zl_safeAreaLayoutGuard"
            view.addLayoutGuide(layoutGuide)
            self.view.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant:0))
            
            self.view.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
            
            self.view.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: self.zl_safeMargin.left))
            
            self.view.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: self.zl_safeMargin.right))
            
            return layoutGuide
        }
    }
    
    
    @objc public var topVC:UIViewController?{
        if let vc = self as? UITabBarController{
            return vc.selectedViewController?.topVC
        }
        if let vc = self as? UINavigationController{
            return vc.viewControllers.last
        }
        if let vc = self.presentedViewController{
            return vc.topVC
        }
        return self
    }
}


// MARK: - 导航栏的背景色（无偏差） 以及按钮位置
/*
 New behavior on iOS 7.
 Default is YES.
 You may force an opaque background by setting the property to NO.
 If the navigation bar has a custom background image, the default is inferred
 from the alpha values of the image—YES if it has any pixel with alpha < 1.0
 If you send setTranslucent:YES to a bar with an opaque custom background image
 it will apply a system opacity less than 1.0 to the image.
 If you send setTranslucent:NO to a bar with a translucent custom background image
 it will provide an opaque background for the image using the bar's barTintColor if defined, or black
 for UIBarStyleBlack or white for UIBarStyleDefault if barTintColor is nil.
 */

@objc public extension UIViewController{
    //方案1 设置背景图片
    @objc public func setNavBarColor(color:UIColor){
        self.navigationController?.navigationBar
            .setBackgroundImage(UIImage.from(color: color), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
    }
    
    @objc public func setNavBarColorAndTranslant(color:UIColor,translant:Bool = false){
        self.navigationController?.navigationBar.isTranslucent = translant
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    @objc public func setNavBarShadleColor(_ color:UIColor?){
        if color == nil{
            self.navigationController?.navigationBar.shadowImage = nil
        }else{
            self.navigationController?.navigationBar.shadowImage = UIImage.from(color: color!,size:CGSize.init(width: 1, height: 1))
        }
    }
    
}
/*
 知识点
 #1楼
 BarMetrics有点类似于按钮的for state状态，即什么状态下显示
 UIBarMetricsDefault-竖屏横屏都有，横屏导航条变宽，则自动repeat图片
 UIBarMetricsCompact-竖屏没有，横屏有，相当于之前老iOS版本里地UIBarMetricsLandscapePhone
 UIBarMetricsCompactPrompt和UIBarMetricsDefaultPrompt暂时不知道用处，官方解释是Applicable only in bars with the prompt property, such as UINavigationBar and UISearchBar，
 */
