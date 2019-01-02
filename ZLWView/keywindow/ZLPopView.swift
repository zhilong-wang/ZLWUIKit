//
//  ZLTitlesScrollV.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/12.
//

import Foundation
import ZLWUIKit


@objc public class  ZLPopView: ZLView {
    
    @objc public var animateDuration:TimeInterval = 0.5
    @objc public var animateStart:((UIView,ZLPopView)->Void)!
    @objc public  var animateEnd:((UIView,ZLPopView)->Void)!
    @objc public var blackBackView:UIView = {
       let view = UIView.init()
        view.backgroundColor = UIColor.zl_hexColor(hex: 0x000000, alpha: 0.5)
        return view
    }()
    var tapHideGesture:UITapGestureRecognizer!
    @objc public var isOnTapHide:Bool = true{
        didSet{
            if isOnTapHide{
                blackBackView.isUserInteractionEnabled = true
            }else{
                blackBackView.isUserInteractionEnabled = false
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOnTapHide = true
        
        animateStart = {(view,popV) in
            view.frame = CGRect.init()
            view.center = popV.center
        }
        animateEnd = {(view,popV) in
            view.frame = popV.viewFrame
            view.center = popV.center
        }
        addSubview(blackBackView)
        blackBackView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideTapClick(_:)))
        blackBackView.addGestureRecognizer(tap)
        
    }
    @objc public convenience init() {
        self.init(frame: CGRect.init())
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public var viewFrame:CGRect = CGRect.init()
    @objc public weak  var  view:UIView?{
        didSet{
            oldValue?.removeFromSuperview()
            guard let v =  view  else {return}
            self.addSubview(v)
            viewFrame = v.frame
        }
    }

    @objc public class func defaultStyle(view:UIView) ->ZLPopView{
        let v = ZLPopView.init(frame: CGRect.init())
        v.backgroundColor = UIColor.zl_hexColor(hex: 0x000000, alpha: 0.5)
        v.view = view
        return v
    }
    @objc public  func show( in view:UIView? = nil ,isAnimate:Bool = true){
        guard  let v = self.view else { return }
        guard  let subView = view ??  UIApplication.shared.keyWindow else { return  }
        subView.addSubview(self)
        self.frame = subView.bounds
        if isAnimate{
            self.animateStart(v,self)
            self.viewFrame = v.frame
            UIView.animate(withDuration: animateDuration) {
                self.animateEnd(v,self)
                self.viewFrame = v.frame
                self.setNeedsLayout()
            }
        }else{
            self.animateEnd(v,self)
        }
        
    }
    @objc public func hideTapClick(_ tap:UITapGestureRecognizer){
        if !self.viewFrame.contains(tap.location(in: self)){
            self.dismiss(isAnimate: true)
        }
    }

    
    @objc public func dismiss(isAnimate:Bool = true){
        guard  let v = view else {
            return
        }
        if isAnimate{
            UIView.animate(withDuration: animateDuration, animations: {
                self.animateStart(v,self)
                self.viewFrame = v.frame
            }) { (b) in
                self.removeFromSuperview()
            }
        }else{
            self.removeFromSuperview()
        }
    }
    
    
    
}


public extension ZLPopView{
    public  class func toastLabel(_ msg:String) ->ZLLabel {
        let label = ZLLabel.init()
        label.textColor = UIColor.red
        label.text = msg
        label .frame = CGRect.init(x: 0, y: 0, width: label.intrinsicContentSize.width + 20, height: label.intrinsicContentSize.height + 40)
        label.backgroundColor = UIColor.zl_hexColor(hex: 0xf5f5f5)
        label.textAlignment = .center
        
        let str = NSString.init(string: msg)
        let rect = str.boundingRect(with: CGSize.init(width: kScreenWidth - 100, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
        let newRect = CGRect.init(x: 0, y: 0, width: rect.size.width + 20, height: rect.size.height + 40)
        label.frame = newRect
        label.numberOfLines = 0
        
        return label
    }
    public static func toast(msg:String,isError:Bool,_ view:UIView? = nil){
        let msgL = toastLabel(msg)
        let v = view ?? UIApplication.shared.keyWindow ?? UIView.init()
        let pop = ZLPopView.init()
        pop.isOnTapHide = false
        pop.blackBackView.backgroundColor = UIColor.clear
        pop.backgroundColor = UIColor.clear
        pop.view = msgL
        
        pop.animateStart = {(view,popV) in
            popV.frame = CGRect.init(origin: CGPoint.init(x: v.frame.size.width/2 - view.frame.size.width / 2 , y: v.frame.size.height * 0.7 ), size: view.frame.size)
            view.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(popV)
            })
            popV.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        }
        pop.animateEnd = {(view,popV) in
            popV.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
        pop.show(in: view, isAnimate: true)
        DispatchQueue.init(label: "sss").async {
            sleep(1)
            DispatchQueue.main.async {
                pop.dismiss()
            }
        }
        
    }
}
