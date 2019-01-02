//
//  ZLMediatior.swift
//  Alamofire
//
//  Created by SJYY on 2018/11/20.
//

import Foundation
public enum ZLMediatiorResult {
    case success(Any?),err(String)
}

public protocol ZLMediatiorServer{
    var router:String{get}
    var param:[String:Any?]?{get}
}

public class ZLMediatior{
    
    public static let share:ZLMediatior = ZLMediatior()
    
    public var handleMap:[String:([String:Any]?)->Any?] = [:]
    public class func register(key:ZLMediatiorServer,handle:@escaping ([String:Any]?)->Any?){
        self.share.handleMap[key.router] = handle
    }
    public class func perform(_ key:ZLMediatiorServer) ->ZLMediatiorResult{
        if let handle = self.share.handleMap[key.router]{
            return .success(handle(key.param ??  [:]))
        }
        return .err("错误")
    }
}


public enum ZLMediRooter{
    case toast(msg:String,attr:[NSAttributedStringKey:Any]?)
    case alert(title:String?,msg:String,cancle:UIAlertAction?,ok:UIAlertAction?)
    case showImg(complete:(UIImageView)->Void)
}
extension ZLMediRooter:ZLMediatiorServer{
    public var router: String {
        switch self {
        case .toast(msg: _, attr: _):
            return "ZLMediRooter_toast"
        case .alert(title: _, msg: _, cancle: _, ok: _):
            return "ZLMediRooter_alert"
        case .showImg(complete: _):
            return "zl_showImg"
        default:
            break
        }
    }
    
    public var param: [String : Any?]? {
        var param : [String:Any]  = [:]
        switch self {
        case .toast(msg: let msg, attr: let attr):
            param["msg"] = msg
            param["attr"] = attr
        case .alert(title: let title, msg: let msg, cancle: let cancle, ok: let ok):
            param["title"] = title
            param["msg"] = msg
            param["cancle"] = cancle
            param["ok"] = ok
        case .showImg(complete: let complete):
            param["complete"] = complete
        default:
            break
        }
        return param
    }
    
    
}
