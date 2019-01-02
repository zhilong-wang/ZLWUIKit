//
//  ZLTitlesScrollV.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/12.
//

import Foundation
import ZLWUI
import SnapKit

public protocol ZLTitleControlDelegate:NSObjectProtocol {
    func zl_titleControlValueChange(tc:ZLTitleControl)
}

@objc public class ZLTitleControl:UISegmentedControl{
    public weak var zlDelegate:ZLTitleControlDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(UIImage.init(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage.init(), for: .selected, barMetrics: .default)
        self.setBackgroundImage(UIImage.init(), for: .highlighted, barMetrics: .default)
        self.setDividerImage(UIImage.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.setDividerImage(UIImage.init(), forLeftSegmentState: .selected, rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(UIImage.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        self.isShowUnderLine = true
        self.addTarget(self, action: #selector(selectedClick), for: .valueChanged)
    }
    public override var selectedSegmentIndex: Int{
        didSet{
            super.selectedSegmentIndex = selectedSegmentIndex
            updataUnderLine()
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public var selectedUnderLine:ZLView = {
        let view = ZLView.init(frame: CGRect.init())
        view.zl_intrisizeHeight = 2
        view.zl_intrisizeWidth = 73
        view.tag = 89999
        
        return view
    }()
    
    public var segmentWidth:CGFloat = 73{
        didSet{
            for i in 0..<self.numberOfSegments {
                setWidth(segmentWidth, forSegmentAt: i)
            }
        }
    }
    public var normalStyle:(UIColor,UIFont)?{
        didSet{
            guard let style = normalStyle else{return}
            self.setTitleTextAttributes([NSAttributedStringKey.font:style.1,NSAttributedStringKey.foregroundColor:style.0], for: .normal)
        }
    }
    public var selectedStyle:(UIColor,UIFont)?{
        didSet{
            guard let style = selectedStyle else{return}
            self.setTitleTextAttributes([NSAttributedStringKey.font:style.1,NSAttributedStringKey.foregroundColor:style.0], for: .selected)
        }
    }
    public  var highlightedStyle:(UIColor,UIFont)?{
        didSet{
            guard let style = highlightedStyle else{return}
            self.setTitleTextAttributes([NSAttributedStringKey.font:style.1,NSAttributedStringKey.foregroundColor:style.0], for: .highlighted)
        }
    }
    
    public override func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) {
        super.insertSegment(withTitle: title, at: segment, animated: animated)
        setWidth(segmentWidth, forSegmentAt: segment)
    }
    public var isShowUnderLine:Bool = true{
        didSet{
            updataUnderLine()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updataUnderLine()
    }
    public var titles:[String] = [] {
        didSet{
            self.removeAllSegments()
            for i in 0..<titles.count {
                self.insertSegment(withTitle:titles[i] , at: i, animated: false)
            }
        }
    }
}
extension ZLTitleControl{
    @objc public func selectedClick(){
        self.zlDelegate?.zl_titleControlValueChange(tc: self)
        updataUnderLine()
    }
    
    //关于约束 的问题，放在一些不能用约束的地方会有问题
    public func updataUnderLine(){
        if isShowUnderLine{
            guard self.frame.size.height > 0 else{return}
            addSubview(selectedUnderLine)
            bringSubview(toFront: selectedUnderLine)
            if numberOfSegments > 0{
                let width = selectedUnderLine.zl_intrisizeWidth
                let height = selectedUnderLine.zl_intrisizeHeight
                
                selectedUnderLine.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
                selectedUnderLine.center = CGPoint.init(x: CGFloat(self.selectedSegmentIndex ) * segmentWidth + segmentWidth/2, y: self.frame.size.height - height/2)
                
//                selectedUnderLine.snp.remakeConstraints { (make) in
//                    make.bottom.equalTo(self).offset(-2)
//                    make.centerX.equalTo(self.snp.left)
//                        .offset(CGFloat(self.selectedSegmentIndex ) * segmentWidth + segmentWidth/2)
//                }
            }
        }else{
            selectedUnderLine.removeFromSuperview()
        }
    }
}
