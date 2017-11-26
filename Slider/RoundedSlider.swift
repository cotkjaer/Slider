//
//  RoundedSlider.swift
//  Slider
//
//  Created by Christian Otkjær on 27/01/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

@IBDesignable
open class RoundedSlider: UIView, Slider
{
    open var delegate: SliderDelegate?
        {
        didSet { animateSlide(to: value) }
    }
    
    @IBInspectable
    open var minValue: Float = 0
    
    @IBInspectable
    open var maxValue: Float = 1
    
    private var _value: Float = 0.5
    
    @IBInspectable
    open var value: Float
        {
        set
        {
            let realValue = min(maxValue, max(minValue, newValue))
            
            guard realValue != _value else { return }
            
            animateSlide(to: realValue)
        }
        get
        {
            return _value
        }
    }
    
    /** Basic linear interpolation between two floating-point values
     - parameter a: the lower end of the interpolated range
     - parameter b: the upper end of the interpolated range
     - parameter t: the "time", is supposed to be in [0;1], but over-/under-shooting can be desired in certain situations
     - returns: interpolation of a and b by t (a * (1 - t) + b * t)
     */
    @inline(__always)
    func lerp(_ a: Float, _ b: Float, _ t: Float) -> Float
    {
        return (a * (1 - t) + b * t)
    }
    
    open var progress: Float
        {
        get { return factor() }
        set { value = lerp(minValue, maxValue, min(1, max(0, newValue))) }
    }
    
    private func factor(minValue: Float? = nil, maxValue: Float? = nil, value: Float? = nil) -> Float
    {
        let minValue = minValue ?? self.minValue
        let maxValue = maxValue ?? self.maxValue
        let value = value ?? self.value
        
        return (value - minValue) / (maxValue - minValue)
    }
    
    // MARK: - Views
    
    // MARK: Track
    
    public let trackView = UIView()
    
    @IBInspectable
    open var trackInsets: UIEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var trackColor: UIColor?
        {
        get { return trackView.backgroundColor }
        set { trackView.backgroundColor = newValue }
    }

    // MARK: Bar
    
    public let barView = UIView()
    
    @IBInspectable
    open var barInsets: UIEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        {
        didSet { setNeedsLayout() }
    }

    
    @IBInspectable
    open var barColor: UIColor?
        {
        get { return barView.backgroundColor }
        set { barView.backgroundColor = newValue }
    }
    
    // MARK: Thumb
    
    public let thumbView = UIView()
    
    @IBInspectable
    open var thumbInsets: UIEdgeInsets = UIEdgeInsets()//top: 1, left: 1, bottom: 1, right: 1)
    {
        didSet { setNeedsLayout() }
    }
    
    // MARK: Text
    
    private let thumbLabel = UILabel()
    
    @IBInspectable
    open var thumbText: String?
        {
        get { return thumbLabel.text }
        set { thumbLabel.text = newValue }
    }
    
    @IBInspectable
    open var thumbFont: UIFont
        {
        get { return thumbLabel.font }
        set { thumbLabel.font = newValue }
    }
    
    @IBInspectable
    open var thumbTextColor: UIColor
        {
            get { return thumbLabel.textColor }
            set { thumbLabel.textColor = newValue }
    }
    
    // MARK: Image

    private let thumbImageView = UIImageView(image: nil)

    @IBInspectable
    open var thumbImage: UIImage?
    {
        get { return thumbImageView.image }
        set { thumbImageView.image = newValue }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup()
    {
        layoutSubviews()
        
        addSubview(trackView)
        addSubview(barView)
        addSubview(thumbView)
        
        thumbImageView.contentMode = .scaleAspectFit
        thumbView.addSubview(thumbImageView)

        thumbLabel.textAlignment = .center
        thumbView.addSubview(thumbLabel)
        
        addGestureRecognizers()
    }
    
    // MARK: - Layout
    
    open var orientation: SliderOrientation = .automatic
    
    private var currentOrientation: SliderOrientation
    {
        switch orientation
        {
        case .automatic:
            
            if bounds.width > bounds.height
            {
                // TODO: reading direction
                
                return .leftToRight
            }
            else
            {
                return .bottomToTop
            }
            
            
        default:
            return orientation
        }
    }
    
    open override func layoutSubviews()
    {
        layoutSubviews(forValue: value)

        super.layoutSubviews()
    }
    
    private func layoutSubviews(forValue value: Float)
    {
        trackView.frame = trackFrame()
        trackView.roundCorners()
        
        barView.frame = barFrame(trackRect: trackView.frame, value: value)
        barView.roundCorners()
        
        let tFrame = thumbFrame(barRect: barView.frame)
        thumbView.frame = tFrame
        thumbView.roundCorners()
        
        thumbLabel.frame = thumbView.bounds
        thumbLabel.roundCorners()
        
        thumbImageView.frame = thumbView.bounds
        thumbImageView.roundCorners()
    }
    
    // MARK: Frames
    
    func trackFrame(forBounds bounds: CGRect? = nil) -> CGRect
    {
        let bounds = bounds ?? self.bounds
        
        return trackInsets.apply(to: bounds)
    }
    
    func barFrame(forBounds bounds: CGRect? = nil, trackRect: CGRect? = nil, value: Float? = nil) -> CGRect
    {
        let bounds = bounds ?? self.bounds
        let trackRect = barInsets.apply(to: trackRect ?? trackFrame(forBounds: bounds))
        let value = value ?? self.value
        
        let barFrame: CGRect
        switch currentOrientation
        {
        case .automatic:
           fallthrough
        
        case .leftToRight:
            let height = trackRect.height
            let width = (trackRect.width - height) * CGFloat(factor(value: value))

            barFrame = CGRect(x: trackRect.minX, y: trackRect.minY, width: height + width, height: height)
            
        case .rightToLeft:
            let height = trackRect.height
            let width = (trackRect.width - height) * CGFloat(factor(value: value))
            
            return CGRect(x: trackRect.maxX - (height + width), y: trackRect.minY, width: height + width, height: height)

        case .bottomToTop:
            
            let width = trackRect.width
            let height = (trackRect.height - width) * CGFloat(factor(value: value))
            
            barFrame = CGRect(x: trackRect.minX, y: trackRect.maxY - (height + width), width: width, height: height + width)
            
        case .topToBottom:
            
            let width = trackRect.width
            let height = (trackRect.height - width) * CGFloat(factor(value: value))
            
            barFrame = CGRect(x: trackRect.minX, y: trackRect.minY, width: width, height: height + width)
        }
        
        return barFrame
    }
    
    func thumbFrame(forBounds bounds: CGRect? = nil, trackRect: CGRect? = nil, barRect: CGRect? = nil, value: Float? = nil) -> CGRect
    {
        let bounds = bounds ?? self.bounds
        let trackRect = trackRect ?? trackFrame(forBounds: bounds)
        let value = value ?? self.value
        let barRect = thumbInsets.apply(to: barRect ?? barFrame(forBounds: bounds, trackRect: trackRect, value: value))
        
        let thumbFrame: CGRect
        
        switch currentOrientation
        {
        case .automatic:
            fallthrough
            
        case .leftToRight:
            
            thumbFrame = CGRect(x: barRect.maxX - barRect.height, y: barRect.minY, width: barRect.height, height: barRect.height)
            
        case .rightToLeft:

            thumbFrame = CGRect(x: barRect.minX, y: barRect.minY, width: barRect.height, height: barRect.height)
            
        case .bottomToTop:
            
            thumbFrame = CGRect(x: barRect.minX, y: barRect.minY, width: barRect.width, height: barRect.width)

            
        case .topToBottom:
            
            thumbFrame = CGRect(x: barRect.minX, y: barRect.maxY - barRect.width, width: barRect.width, height: barRect.width)
        }
        
        return thumbFrame
        
    }
    
    // MARK: - Slide Animation
    
    func animateSlide(to: Float, duration: Double = SliderAnimator.DefaultSliderAnimationDuration, completion: ((Bool)->())? = nil)
    {
        let animator = SliderAnimator(fromValue: value, toValue: to, duration: duration, animation: {
            self._value = to
            self.layoutSubviews(forValue: to)
        }, completion: completion)
        
        delegate?.slider(self, willAnimateWithAnimator: animator)
        
        animator.animate()
    }
    
    // MARK: - Gestures
    
    @IBInspectable
    open var numberOfTapsRequiredToSlide: Int = 1 { didSet { tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequiredToSlide } }
    
    func createTapRecognizer() -> UITapGestureRecognizer
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tap.numberOfTapsRequired = numberOfTapsRequiredToSlide
        
        return tap
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = self.createTapRecognizer()
    
    func addGestureRecognizers()
    {
        addGestureRecognizer(tapGestureRecognizer)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(type(of: self).handlePan(_:)))
        
        addGestureRecognizer(pan)
    }
    
    func value(for gesture: UIGestureRecognizer) -> Float
    {
        var location = gesture.location(in: self)
        
        let ff = thumbInsets.apply(to: barInsets.apply(to: trackFrame()))
        
        let thumbSize = thumbFrame().size
        
        let f = ff.insetBy(dx: thumbSize.width / 2, dy: thumbSize.height / 2)
        
        location.x = min(f.maxX, max(f.minX, location.x))
        location.y = min(f.maxY, max(f.minY, location.y))
        
        let t: Float

        switch currentOrientation
        {
        case .automatic:
            fallthrough
            
        case .leftToRight:
            
            t = Float((location.x - f.minX) / f.width)
            
        case .rightToLeft:
            
            t = Float((f.maxX - location.x) / f.width)
            
        case .bottomToTop:
            
            t = Float((f.maxY - location.y) / f.height)
            
        case .topToBottom:

            t = Float((location.y - f.minY) / f.height)
        }
        
        let v = lerp(minValue, maxValue, t)
        
        return v

        
//        let f = trackFrame().insetBy(dx: thumbFrame().width / 2, dy: 0)
//        
//        location.x = min(f.maxX, max(f.minX, location.x))
//        
//        let t = Float((location.x - f.minX) / f.width)
//        
//        let v = lerp(minValue, maxValue, t)
        //                return v
    }
    
    func snap(gesture: UIGestureRecognizer)
    {
        var v = value(for: gesture)
        
        if let adjustedV = delegate?.slider(self, willEndSlidingWithProposedValue: v)
        {
            v = adjustedV
        }
        
        animateSlide(to: v, duration: SliderAnimator.DefaultSliderSnapAnimationDuration) { _ in
            self.delegate?.slider(self, didEndSlidingWithFinalValue: self.value)
        }
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer)
    {
        delegate?.slider(self, willBeginSlidingWithInitialValue: value)
        snap(gesture: tap)
    }
    
    var trackingPan: Bool = false
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer)
    {
        switch pan.state
        {
        case .began:
            
            trackingPan = true
            
            delegate?.slider(self, willBeginSlidingWithInitialValue: value)
            
            fallthrough
            
        case .changed:
            
            guard trackingPan else { return }
            
            animateSlide(to: value(for: pan), duration: SliderAnimator.DefaultSliderTrackAnimationDuration)
            
        default:
            
            guard trackingPan else { return }
            
            snap(gesture: pan)
            
            trackingPan = false
        }
    }
}


