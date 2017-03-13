//
//  SliderAnimator.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

public class SliderAnimator
{
    public static var DefaultSliderAnimationDuration: Double = 0.25
    public static var DefaultSliderSnapAnimationDuration: Double = 0.25
    public static var DefaultSliderTrackAnimationDuration: Double = 0.1
    
    public let fromValue: Float
    public let toValue: Float

    public let duration: Double
    private var animations: [()->()]
    private var completions: [(Bool)->()] = []
    
    init(fromValue: Float, toValue: Float, duration: Double, animation: @escaping ()->(), completion: ((Bool)->())?)
    {
        self.toValue = toValue
        self.fromValue = fromValue
        self.duration = duration
        self.animations = [animation]
        if let completion = completion { completions.append(completion) }
    }
    
    public func animatedAlongside(animation: @escaping ()->(), completion: ((Bool)->())?)
    {
        animations.append(animation)
        if let completion = completion { completions.append(completion) }
    }
    
    internal func doAnimations() { animations.forEach { $0() } }
    
    internal func doCompletions(completed: Bool) { completions.forEach { $0(completed) } }
    
    internal func animate()
    {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.beginFromCurrentState, .allowAnimatedContent, .allowUserInteraction],
            animations: doAnimations,
            completion: doCompletions)
    }
}
