//
//  ZLAppVersion.swift
//  Alamofire
//
//  Created by SJYY on 2018/12/19.
//

import Foundation
public class ZLAppVersion{
    public static var version:String{
        if let info = Bundle.main.infoDictionary{
            if let ss = info["CFBundleShortVersionString"] as? String{
                return ss
            }
        }
        return "1"
    }
    public static var storeAppId:String = ""
    public static var itunesCheck :String{
        return "http://itunes.apple.com/cn/linkmore?id=\(storeAppId)"
    }
    public class func getAppStoreVersion(resp:[String:Any]) ->String{
        if let arr = resp["results"] as? [Any]{
            if let dic = arr.first as? [String:Any]{
                if let ver = dic["appStoreVersion"] as? String{
                    return ver
                }
            }
        }
        return ""
    }
    public class func goToItunes(){
        if let url = URL.init(string: "itms-apps://url.cn/\(storeAppId)"){
            UIApplication.shared.openURL(url)
        }
    }
    
}
