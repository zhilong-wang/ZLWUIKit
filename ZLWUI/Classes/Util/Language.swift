import Foundation

// MARK: - 多语言扩展
public extension String{
    public var local:String{
        return ZLLanguage.LocalizedFor(key: self)
    }
}
@objc public extension NSString{
    @objc public var local:String{
        return ZLLanguage.LocalizedFor(key: String.init(self))
    }
}

@objc public protocol ZLLanguageDelegate{
    @objc func pathFor( key:String)->String
}


/// 语言类型
///
/// - en: 以ing鱼
/// - zh_Hant: 繁体
/// - zh_Hans: 简体
public enum  ZLLanguageType:String {
    case en = "en"
    case zh_Hant = "zh-Hant"
    case zh_Hans = "zh-Hans"
}
 //MARK: 多语言
@objc public class ZLLanguage:NSObject{
    // en zh-hans zh-hant
    @objc public static let share:ZLLanguage = ZLLanguage.init()
    override init() {
        super.init()
        languageKey = UserDefaults.standard.value(forKey: "LanguageKey") as? String ?? NSLocale.preferredLanguages.first ?? "zh-Hans"
        if languageKey.hasPrefix("zh-Hans"){
            languageKey = ZLLanguageType.zh_Hans.rawValue
        }else if languageKey.hasPrefix("zh-Hant"){
            languageKey = ZLLanguageType.zh_Hant.rawValue
        }else{
            languageKey = ZLLanguageType.en.rawValue
        }
        UserDefaults.standard.setValue(languageKey, forKey: "LanguageKey")
    }
    @objc public var languageKey:String = "en"{
        didSet{
            UserDefaults.standard.setValue(languageKey, forKey: "LanguageKey")
        }
    }
    @objc public weak var  delegate:ZLLanguageDelegate?
    
    @objc public class func LocalizedFor(key:String,comment:String? = nil,table:String? = "Localizable") -> String{
        if let path = share.delegate?.pathFor(key: share.languageKey) ?? Bundle.main.path(forResource: "\(share.languageKey)", ofType: "lproj"){
            let str = Bundle.init(path: path)?.localizedString(forKey: key, value: nil, table: table ?? "Localizable")
            return str ?? key
        }else{
            let str = NSLocalizedString(key, comment: key)
            return str
        }
    }
}

