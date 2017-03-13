//
//  SliderOrientation.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

public enum SliderOrientation: Int
{
    /// horizontal if `bounds.width > bounds.height`, vertical otherwise
    case automatic = 0
    
    /// slider is oriented vertically with min-value at the top end and max-value at the bottom end
    case topToBottom
    
    /// slider is oriented vertically with min-value at the bottom end and max-value at the top end
    case bottomToTop
    
    /// slider is oriented horizontally with min-value at the left end and max-value at the right end
    case leftToRight
    
    /// slider is oriented horizontally with min-value at the right end and max-value at the left end
    case rightToLeft
}
