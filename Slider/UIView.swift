//
//  UIView.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit

// MARK: - <#comment#>

extension UIView
{
    func roundCorners()
    {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

