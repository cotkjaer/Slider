//
//  SliderDelegate.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

public protocol SliderDelegate
{
    func slider(_ slider: Slider, willBeginSlidingWithInitialValue initialValue: Float)
    
    func slider(_ slider: Slider, willEndSlidingWithProposedValue proposedValue: Float) -> Float?
    
    func slider(_ slider: Slider, didEndSlidingWithFinalValue finalValue: Float)
    
    func slider(_ slider: Slider, willAnimateWithAnimator animator: SliderAnimator)
}
