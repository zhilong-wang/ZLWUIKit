
import Foundation

public protocol ZLSlideDelegate:NSObjectProtocol{
    func zlSlide_viewForPoint(_ point:CGFloat)->UIView
    func zlSlide_viewConfig(slide:ZLSlider,view:UIView,point:CGFloat)
    func zlSlide_viewPosition(slide:ZLSlider,view:UIView,point:CGFloat) ->CGRect
}
public protocol  ZLSlideDataDelegate :NSObjectProtocol{
    func zlSlide_valueChange(slide:ZLSlider)->Void
}

@objc open class  ZLSlider :UISlider{
    public weak var zlDelegate:ZLSlideDelegate?
    public weak var zlDataDelegate:ZLSlideDataDelegate?
    open override var value: Float{
        didSet{
            super.value = value
            self.pointColorChange()
        }
    }
    var isPointOnly:Bool = false{
        didSet{
            if isPointOnly {
                self.isContinuous = false
            }else{
                self.isContinuous = true
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumValue = 0
        self.minimumValue = 0
        self.value = 0
        self.initView()
    }
    
    open override var maximumTrackTintColor: UIColor?{
        didSet{
            super.maximumTrackTintColor = maximumTrackTintColor
            self.pointColorChange()
        }
    }
    open override var minimumTrackTintColor: UIColor?{
        didSet{
            super.minimumTrackTintColor = minimumTrackTintColor
            self.pointColorChange()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initView(){
        self.addTarget(self, action: #selector(valueChaneg), for: .valueChanged)
        self.zlDelegate = self
    }
    @objc public var points:[CGFloat]?{
        didSet{
            guard let pointArr = points else { pointsLayers = [:]; return}
            var map :[CGFloat:UIView] = [:]
            pointArr.forEach {[unowned self] (point) in
                let layer = self.zlDelegate?.zlSlide_viewForPoint(point)
                map[point] = layer
            }
            pointsLayers = map
        }
    }
    //point 0.0 - 1
    public var pointsLayers:[CGFloat:UIView]?{
        didSet{
            oldValue?.forEach({ (item) in
                item.value.removeFromSuperview()
            })
            self.pointsLayers?.forEach({ [unowned self](item) in
                self.addSubview(item.value)
                self.sendSubview(toBack: item.value)
            })
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        pointsLayers?.forEach({ [unowned self](item) in
            item.value.frame = (self.zlDelegate?.zlSlide_viewPosition(slide: self, view: item.value, point:item.key)) ?? CGRect.init()
        })
    }
    
    var preValue:Float = 0
}

extension ZLSlider{
    @objc private func valueChaneg(){
        if isPointOnly{
            makePointOnly()
        }
        self.pointColorChange()
        self.zlDataDelegate?.zlSlide_valueChange(slide: self)
    }
    @objc public func pointColorChange(){
        pointsLayers?.forEach({ [unowned self](item) in
            self.zlDelegate?.zlSlide_viewConfig(slide: self, view: item.value, point: item.key)
        })
    }
    func makePointOnly(){
        guard self.maximumValue > self.minimumValue else {
            return
        }
        var left:Float = self.minimumValue
        var right:Float = self.maximumValue
        if let arr = points {
            for i in arr{
                left = max(Float(i) * (self.maximumValue - self.minimumValue), left)
                right = min(Float(i) * (self.maximumValue - self.minimumValue), right)
            }
            if preValue < value{
                self.value = right
            }else{
                self.value = left
            }
            preValue = self.value
        }
    }
}

extension ZLSlider:ZLSlideDelegate{

    
    public func zlSlide_viewForPoint(_ value: CGFloat) -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        if value == 0{
            view.backgroundColor = self.minimumTrackTintColor
        }else{
            view.backgroundColor = self.maximumTrackTintColor
        }
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }
    public func zlSlide_viewConfig(slide: ZLSlider, view: UIView, point: CGFloat) {
        view.backgroundColor = slide.maximumTrackTintColor
        let amV = slide.maximumValue - slide.minimumValue
        guard  amV > 0 else {
            super.value = 0
            return
        }
        let v = Float(point) * amV + slide.minimumValue
        if v > slide.value{
            view.backgroundColor = slide.maximumTrackTintColor
        }else{
            view.backgroundColor = slide.minimumTrackTintColor
        }
        
    }
    public func zlSlide_viewPosition (slide: ZLSlider, view: UIView, point: CGFloat)->CGRect {
        let x = point * (slide.frame.size.width - 10)
        let h = slide.frame.size.height/2 - 5
        return CGRect.init(x: x, y: h, width: 10, height: 10)
    }
}
