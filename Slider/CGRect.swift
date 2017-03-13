//
//  CGRect.swift
//  Slider
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import Foundation

// MARK: - <#comment#>

extension UIEdgeInsets
{
    func apply(to rect: CGRect) -> CGRect
    {
        return CGRect(x: rect.origin.x + left,
                      y: rect.origin.y + top,
                      width: rect.width - (left + right),
                      height: rect.height - (top + bottom))
    }
}
