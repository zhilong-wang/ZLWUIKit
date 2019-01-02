//
//  ZLDrawSelected.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/9.
//

import Foundation
@objc public  class ZLDrawSelectTableView:UITableView{
    
    @objc public var maxHeight:CGFloat = 100
    //MARK: initial
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 当重新加载数据是重新设置frame
    public override func reloadData() {
        super.reloadData()
        self.perform(#selector(resizeFrame), with: nil, afterDelay: 0.1)
    }
    @objc public func resizeFrame(){
        let h = self.contentSize.height
        self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: h)
    }
}
