//
//  Frame+ZL.swift
//  Alamofire
//
//  Created by SJYY on 2018/11/9.
//

import Foundation

public extension CGRect{
    public func setX(_ x :CGFloat) ->CGRect{
        return CGRect.init(x: x, y: self.origin.y, width: self.size.width, height: self.size.height)
    }
    public func setY(_ y :CGFloat) ->CGRect{
        return CGRect.init(x: self.origin.x, y: CGFloat(y), width: self.size.width, height: self.size.height)
    }
    public func setWidth(_ width :CGFloat) ->CGRect{
        return CGRect.init(x: self.origin.x, y: self.origin.y, width: width, height: self.size.height)
    }
    public func setHeight(_ height :CGFloat) ->CGRect{
        return CGRect.init(x: self.origin.x, y: self.origin.y, width: self.size.width, height: height)
    }
}
