//
//  String+Tool.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//

import Foundation

public typealias Attributes = [NSAttributedStringKey:Any]
// MARK: - String 常用的方法
public  extension String{
    
    //小数点后面位数
    var zl_doubleLength:Int{
        return self.zl_separatorToArray(c: ".").last?.count ?? 0
    }
    //专程数据
    public var zl_decimal:Decimal{
        return Decimal.init(string: self) ?? Decimal.init(0)
    }
    /// 转成array
    func zl_separatorToArray(c:Character) ->[String]{
        return self.split(separator: c).map { (subs) -> String in
            return String.init(subs)
        }
    }
    /// 拷贝到剪贴板
    public func zl_Copy(){
        let pastBoard = UIPasteboard.general
        pastBoard.string = self;
    }
    /// 属性字符串
    public func zl_attr(_ color:UIColor? = nil,font:UIFont? = nil,linespace:CGFloat? = nil) -> NSMutableAttributedString{
        let attrs = NSMutableAttributedString.zl_AttrParamMake(color: color, font: font,lineSpace: linespace ?? 0)
        return NSMutableAttributedString.init(string: self, attributes: attrs)
    }
    
    /// 是否邮箱
    public var zl_isEmail: Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailText.evaluate(with: self)
    }
    
    /// 是否数字
    public var zl_isNumber:Bool {
        let numberRegex = "^[0-9]+([.]{0,1}[0-9]+){0,1}$"
        let numberText = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        return numberText.evaluate(with:self)
    }
    
    /// 字符串 返回小数点后面固定位数的数字 因为小数点太长会有精度问题，会自动给一些方法
    public func zl_DoubleStr(_ f:Int,appendZero:Bool = true)-> String{
        let value = Decimal.init(string: self) ?? Decimal.init(0)
        let valueString = "\(value)"
        
        let arrays = valueString.split(separator: ".")
        guard arrays.count <= 2 && arrays.count > 0  else { return ""  }
        let intStr = arrays[0]
        
        var floatStr = ""
        if arrays.count == 2{
            floatStr = String(arrays[1])
        }
        floatStr = String(floatStr.prefix(f))
        if appendZero{
            if floatStr.count < f{
                for _ in 0..<(f - floatStr.count){
                    floatStr = floatStr + "0"
                }
            }
        }
        if floatStr == ""{
            return "\(intStr)"
        }
        return "\(intStr).\(floatStr)"
    }
}

@objc public extension NSAttributedString{
    public class func zl_AttrParamMake(color:UIColor? = nil,font:UIFont? = nil,lineSpace:CGFloat = 2) -> Attributes{
        var param:Attributes = [:]
        if let f = font{
            param[NSAttributedStringKey.font] = f
        }
        if let c = color{
            param[.foregroundColor] = c
        }
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = lineSpace
        param[.paragraphStyle] = style
        
        return param;
    }
}

public extension Decimal{
    public func zl_double(_ length:Int) ->Decimal{
        let p = pow(Decimal.init(10), length) * self
        let intv = floor(Double("\(p)")  ?? 0)
        return Decimal.init(intv) * pow(0.1, length)
    }
}

// MARK: - objc NSString 的方法
@objc public extension NSString{
    @objc public func zl_regMatch(_ regexString:String) ->Bool{
        let predic = NSPredicate(format: "SELF MATCHES %@", regexString)
        return predic.evaluate(with: self)
    }
    @objc public func zl_attr(_ color:UIColor? = nil,font:UIFont? = nil) -> NSAttributedString{
        let attrs = NSAttributedString.zl_AttrParamMake(color: color, font: font)
        return NSAttributedString.init(string: String.init(self), attributes: attrs)
    }
}



