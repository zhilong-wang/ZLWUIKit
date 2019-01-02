//
//  ZLSmsBtn.swift
//  ZLWView
//
//  Created by SJYY on 2018/11/30.
//

import Foundation
import ZLWUIKit

public protocol ZLSmsBtnDelegate:NSObjectProtocol{
    func zl_titleForTime(_ time:Int) -> String
}
public class  ZLSmsBtn: ZLButton{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.zlDelegate = self
        self.setTitle("获取验证码".local, for: .normal)
        self.zl_cornerRadius(3)
        self.setTitleColor(UIColor.zl_hexColor(hex: 0x333333), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.frame = CGRect.init(x: 0, y: 0, width: self.intrinsicContentSize.width + 6, height: self.intrinsicContentSize.height + 2)
        self.zl_border()
    }
    public convenience init() {
        self.init(frame: CGRect.init())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var timer:Timer?
    var timeLimit:TimeInterval = 60
    var startTime:TimeInterval = Date().timeIntervalSince1970
    weak var zlDelegate:ZLSmsBtnDelegate?
    @objc func timerRun(){
        let x = startTime + timeLimit - Date().timeIntervalSince1970
        if x < 0{
            timer?.invalidate()
            isEnabled = true
        }else{
            setTitle(zlDelegate?.zl_titleForTime(60 - Int(x)), for: .disabled)
            isEnabled = false
        }
    }
    public func startRunTimer(){
        startTime = Date().timeIntervalSince1970
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    public func stopRunTimer(){
        timer?.invalidate()
    }
}

extension ZLSmsBtn:ZLSmsBtnDelegate{
    public func zl_titleForTime(_ time: Int) -> String {
        return "\("剩余".local)\(60 - time)s"
    }
}
