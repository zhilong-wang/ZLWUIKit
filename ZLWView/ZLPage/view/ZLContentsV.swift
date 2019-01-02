//
//  ZLContentsV.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/12.
//

import Foundation
import ZLWUI

/// 一行排列的视图 以及计算大小
@objc open class  ZLContentsV: ZLView {
    @objc public var zlMargin:[UIEdgeInsets] = []
    @objc public var isHorizontal:Bool = true
    @objc public var zlMarginDefault = UIEdgeInsets.init(top: 10, left: 20, bottom: 7, right: 20)
    @objc public var contentViews:[UIView] = []{
        didSet{
            oldValue.forEach{$0.removeFromSuperview()}
            contentViews.forEach { [weak self](v) in
                self?.addSubview(v)
            }
            self.zl_intrisizeWidth = 0.1
            self.zl_intrisizeHeight = 0.1
            var preV:UIView? = nil
            var preMargein:CGFloat = 0
            for i in 0..<contentViews.count {
                let view = contentViews[i]
                let margin = (i < self.zlMargin.count) ? self.zlMargin[i] : self.zlMarginDefault
                
                view.snp.makeConstraints { [weak self,weak preV](make) in
                    guard let v  = self else{ return}
                    if v.isHorizontal{
                        make.bottom.equalTo(v).offset(-1 * margin.bottom)
                        make.top.equalTo(v).offset(margin.top)
                        if preV == nil
                        {
                            make.leading.equalTo(self!.snp.leading).offset(margin.left)
                        }else{
                            make.leading.equalTo(preV!.snp.trailing).offset(margin.left + preMargein)
                        }
                    }else{
                        make.left.equalTo(v).offset(margin.left)
                        make.right.equalTo(v).offset(-1 * margin.right)
                        if preV == nil
                        {
                            make.top.equalTo(v).offset(margin.top)
                        }else{
                            make.top.equalTo(preV!.snp.bottom).offset(margin.top + preMargein)
                        }
                    }
                }
                view.tag = i + 1
                preV = view
                if isHorizontal{
                    self.zl_intrisizeWidth = self.zl_intrisizeWidth + margin.right + margin.left + view.intrinsicContentSize.width
                    self.zl_intrisizeHeight = max(self.zl_intrisizeHeight, margin.top + margin.bottom + view.intrinsicContentSize.height)
                    preMargein = margin.right
                }else{
                    preMargein = margin.bottom
                    self.zl_intrisizeWidth = max(self.zl_intrisizeWidth,margin.left + margin.bottom + view.intrinsicContentSize.width)
                    self.zl_intrisizeHeight = self.zl_intrisizeHeight + margin.top + margin.bottom + view.intrinsicContentSize.height
                }
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}

