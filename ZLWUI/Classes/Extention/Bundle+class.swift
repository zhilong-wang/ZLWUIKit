//
//  Bundle+class.swift
//  ZLWUIKit
//
//  Created by SJYY on 2018/11/8.
//

import Foundation
// MARK: - 获取不同bundle 的图片资源

@objc public extension Bundle{
    @objc public static func get(_ cls:AnyClass,fileName:String? = nil) ->Bundle?{
        let bundle = Bundle.init(for: cls)
        guard  fileName != nil else { return bundle}
        let path = "\(bundle.resourcePath!)/\(fileName!)"
        return Bundle.init(path: path)
    }
}

