//
//  InputView.swift
//  MDTokenManage
//
//  Created by zhilong on 2018/9/5.
//  Copyright © 2018年 SJYY. All rights reserved.
//

import UIKit
import SnapKit
@objc open  class ZLImgScrollV: UIScrollView  {
    
    
    public var imgView:UIImageView = UIImageView.init()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.snp.remakeConstraints {[unowned self] (make) in
            make.center.equalTo(self)
            make.edges.equalTo(self)
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func setZoomScale(_ scale: CGFloat, animated: Bool) {
        super.setZoomScale(scale, animated: animated)
        imgView.transform = imgView.transform.scaledBy(x: scale, y: scale)
    }
}






