
import  Foundation


@objc public protocol ZLPageTitleProtocal:NSObjectProtocol{
    func didSelect( index:Int,pre:Int)
}

@objc public protocol ZLContentsScrollProtocal:NSObjectProtocol{
    func didSelect(view:ZLContentScrollV, index:Int,pre:Int)
}
