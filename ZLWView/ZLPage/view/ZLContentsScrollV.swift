//
//  ZLTitlesScrollV.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/12.
//

import Foundation
import ZLWUI
import SnapKit

@objc open class ZLContentScrollV:UIScrollView{
    @objc public var contentsV = ZLContentsV.init(frame: CGRect.init())
    @objc public weak var zlContentsScrollDelegate:ZLContentsScrollProtocal?
    @objc public var preSelectedIndex:Int = 0
    
    @objc public var contentViews:[UIView] = []{
        didSet{
            
            contentsV.contentViews = contentViews
            contentsV.snp.remakeConstraints { (make) in
                make.height.edges.equalTo(self)
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentsV)
        contentsV.snp.makeConstraints { [unowned self](make) in
            make.height.edges.equalTo(self)
        }
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    open override func awakeFromNib() {
        addSubview(contentsV)
        contentsV.snp.makeConstraints { [unowned self](make) in
            make.height.edges.equalTo(self)
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(contentsV)
        contentsV.snp.remakeConstraints { (make) in
            make.height.edges.equalTo(self)
        }
    }
    
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

// MARK: - 定制的 title的版本
@objc extension ZLContentScrollV{
    @objc public var segmentControlTag :Int{
        return 100001
    }
    @objc public var segmentTitleUnderLineTag :Int{
        return 100002
    }
    @objc public var segmentControl:ZLTitleControl{
        set{
            viewWithTag(segmentControlTag)?.removeFromSuperview()
            newValue.tag = segmentControlTag
            addSubview(newValue)
            newValue.snp.makeConstraints { (make) in
                make.height.edges.equalTo(self)
            }
            newValue.zlDelegate = self
           
        }get{
            if let view = viewWithTag(segmentControlTag) as? ZLTitleControl {
                return view
            }
            let seg = ZLTitleControl.init(frame: CGRect.init())
            self.segmentControl = seg
            seg.backgroundColor = UIColor.white
            seg.selectedSegmentIndex = 0
            seg.zlDelegate = self
            return seg
        }
    }
    @objc public var titles:[String] {
        set{
            self.segmentControl.removeAllSegments()
            for i in 0..<newValue.count {
                self.segmentControl.insertSegment(withTitle: newValue[i], at: i, animated: false)
            }
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
        get{
            var arr :[String] = []
            for i in 0..<self.segmentControl.numberOfSegments {
                let str = segmentControl.titleForSegment(at: i)
                arr.append(str ?? "")
            }
            return arr
        }
    }
    
//    @objc public func segmentValueChange(_ segment:UISegmentedControl){
//        guard segment.selectedSegmentIndex >= 0 else {
//            return
//        }
//        self.zlContentsScrollDelegate?.didSelect(view: self, index: segment.selectedSegmentIndex, pre: preSelectedIndex)
//        preSelectedIndex = segment.selectedSegmentIndex
//    }
}

extension ZLContentScrollV:ZLTitleControlDelegate{
    public func zl_titleControlValueChange(tc segment: ZLTitleControl) {
        guard segment.selectedSegmentIndex >= 0 else {
            return
        }
        self.zlContentsScrollDelegate?.didSelect(view: self, index: segment.selectedSegmentIndex, pre: preSelectedIndex)
        preSelectedIndex = segment.selectedSegmentIndex
    }
}



