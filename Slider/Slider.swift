//
//  Slider.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

public protocol Slider
{
    var delegate : SliderDelegate? { set get }
    
    var minValue: Float { set get }
    
    var maxValue: Float { set get }
    
    /// The value should in the [min;max] will be clamped to this range
    var value: Float { set get }
    
    /// The progress from min to max represented by a value in the [0;1] range
    var progress: Float { set get }
    
//    var thumbView: UIView { get }
//    var trackView: UIView { get }
//    var barView: UIView { get }
}
