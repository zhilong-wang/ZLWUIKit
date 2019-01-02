//
//  ZLBaseView.swift
//  FBSnapshotTestCase
//
//  Created by SJYY on 2018/11/9.
//

import Foundation

/// 屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height

@objc open class ZLView:UIView{
    /// 设置返回的intri
    @objc public var zl_intrisizeHeight:CGFloat = 0{
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    /// intrisize 的宽度
    @objc public var zl_intrisizeWidth:CGFloat = 0{
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize{
        let h = zl_intrisizeHeight != 0 ? zl_intrisizeHeight : super.intrinsicContentSize.height
        let w = zl_intrisizeWidth != 0 ? zl_intrisizeWidth : super.intrinsicContentSize.width
        return CGSize.init(width: w, height: h)
    }
    
    /// 设置渐变色 从右到左
    @objc public func setGradualChangingBackgroundColor(_ from:UIColor, to:UIColor){
        self.zl_gradualLayer.colors = [from.cgColor,to.cgColor]
        self.zl_gradualLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        self.zl_gradualLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        self.zl_gradualLayer.locations = [NSNumber.init(value: 0.1),NSNumber.init(value: 0.9)]
    }
    /// 当更新子视图的时候更新一下渐变色layer 的frame
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.zl_gradualLayer.frame = self.bounds
    }
}

@objc open class ZLLabel:UILabel{
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

@objc open class ZLImageView:UIImageView{
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

@objc open class ZLCollectionView:UICollectionView{
    /// 设置返回的intri
    @objc public var zl_intrisizeHeight:CGFloat = 0{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    /// intrisize 的宽度
    @objc public var zl_intrisizeWidth:CGFloat = 0{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize{
        let h = zl_intrisizeHeight != 0 ? zl_intrisizeHeight : super.intrinsicContentSize.height
        let w = zl_intrisizeWidth != 0 ? zl_intrisizeWidth : super.intrinsicContentSize.width
        return CGSize.init(width: w, height: h)
    }
}
@objc open class ZLScrollView:UIScrollView{
    /// 设置返回的intri
    @objc public var zl_intrisizeHeight:CGFloat = 0{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    /// intrisize 的宽度
    @objc public var zl_intrisizeWidth:CGFloat = 0{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize{
        let h = zl_intrisizeHeight != 0 ? zl_intrisizeHeight : super.intrinsicContentSize.height
        let w = zl_intrisizeWidth != 0 ? zl_intrisizeWidth : super.intrinsicContentSize.width
        return CGSize.init(width: w, height: h)
    }
}

