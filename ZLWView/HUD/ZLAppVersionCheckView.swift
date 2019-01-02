//
//  ZLAppVersionCheckView.swift
//  QuickDax
//
//  Created by SJYY on 2018/12/20.
//  Copyright © 2018年 baizhaolei. All rights reserved.
//

import Foundation
import ZLWUIKit
import SnapKit
public class ZLAppVersionCheckView:ZLView{
    public var icon:UIImageView = {
        var imgv = ZLImageView.init()
        imgv.image = UIImage.init(named: "AppIcon")
        return imgv
    }()
    public var titleL:ZLLabel = {
        var l = ZLLabel.init()
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        l.text = "发现".local
        return l
    }()
    public var titleLeftL:ZLLabel = {
        var l = ZLLabel.init()
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.text = "新版本".local
        return l
    }()
    public var versionL:ZLLabel = {
        var l = ZLLabel.init()
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.text = "V1.1".local
        return l
    }()
    public var updateHandle:()->Void = {}
    public var lineColor:UIColor = UIColor.zl_hexColor(hex: 0xeeeeee)
    public var pop:ZLPopView = {
        var pop = ZLPopView.init(frame: CGRect.init())
        pop.isOnTapHide = false
        pop.backgroundColor = UIColor.clear
        pop.animateDuration = 0.5
        pop.animateStart = { (view,popv) in
            view.snp.remakeConstraints { (make) in
                make.center.equalTo(popv)
            }
            view.transform = view.transform.scaledBy(x: 0.2, y: 0.2)
        }
        pop.animateEnd = { (view,popv) in
            view.transform = view.transform.scaledBy(x: 5, y: 5)
        }
        return pop
    }()
    public var topIcon:ZLImageView = {
        let v = ZLImageView.init(image: UIImage.init(named: "versionC"))
        return v
    }()
    var contentV:ZLView = {
        var view = ZLView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    public var updateBtn:UIButton = {
        var btn  = UIButton.init()
        btn.setTitle("更新".local, for: .normal)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    public var cancleBtn:UIButton = {
        var btn  = UIButton.init()
        btn.setTitle("取消".local, for: .normal)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    public var textView:UITextView = {
        var textv = UITextView.init()
        textv.isEditable = false
        let x = "12354678865432\n324567867554235678654\n1234657434523567434256\n235463542356"
        let pa = NSMutableParagraphStyle.init()
        pa.lineSpacing = 15
        
        textv.attributedText = NSAttributedString.init(string: x, attributes: [NSAttributedStringKey.paragraphStyle:pa,NSAttributedStringKey.foregroundColor:UIColor.zl_hexColor(hex: 0x666666),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
        return textv
    }()
    
    public var isMustUpdate:Bool = false{
        didSet{
            initView()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topIcon)
        addSubview(contentV)
        
        self.backgroundColor = UIColor.clear
        topIcon.snp.remakeConstraints { (make) in
            make.centerX.top.equalTo(self)
        }
        contentV.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topIcon.snp.bottom)
        }
        contentV.addSubview(textView)
        textView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.contentV).offset(20)
            make.center.equalTo(self.contentV)
            make.top.equalTo(self.contentV).offset(0)
        }
        updateBtn.addTarget(self, action: #selector(updateVersionClick), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(cancleClick), for: .touchUpInside)
        initView()
        self.zl_cornerRadius(5)
        
        pop.view = self
        
        topIcon.addSubview(icon)
        topIcon.addSubview(titleL)
        topIcon.addSubview(titleLeftL)
        topIcon.addSubview(versionL)
        icon.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(62)
        }
        titleL.snp.remakeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(11)
            make.top.equalToSuperview().offset(51)
        }
        titleLeftL.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleL.snp.right)
            make.bottom.equalTo(self.titleL)
        }
        versionL.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleL)
            make.top.equalTo(self.titleL.snp.bottom)
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        addSubview(updateBtn)
        if !isMustUpdate{
            addSubview(cancleBtn)
            cancleBtn.snp.remakeConstraints { (make) in
                make.left.bottom.equalTo(self)
                make.right.equalTo(self.updateBtn)
                make.width.height.equalTo(self.updateBtn)
            }
            cancleBtn.zl_topLineV.backgroundColor = lineColor
            updateBtn.snp.remakeConstraints { (make) in
                make.right.bottom.equalTo(self)
                make.height.equalTo(50)
            }
            updateBtn.zl_topLineV.backgroundColor =  lineColor
            updateBtn.zl_leftLineV.backgroundColor =  lineColor
        }else{
            cancleBtn.removeFromSuperview()
            updateBtn.snp.remakeConstraints { (make) in
                make.right.left.bottom.equalTo(self)
                make.height.equalTo(50)
            }
            updateBtn.zl_topLineV.backgroundColor =  lineColor
            updateBtn.zl_leftLineV.removeFromSuperview()
        }
        
    }
    override public var intrinsicContentSize: CGSize{
        contentV.zl_intrisizeHeight = textView.contentSize.height + 40
        let h = topIcon.intrinsicContentSize.height + contentV.intrinsicContentSize.height + 50
        let w:CGFloat = 309
        return CGSize.init(width: w, height: h)
    }
    
    @objc func updateVersionClick(){
        updateHandle()
        pop.dismiss()
    }
    @objc func cancleClick(){
        pop.dismiss()
    }
    
}
