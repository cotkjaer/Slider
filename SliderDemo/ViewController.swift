//
//  ViewController.swift
//  SliderDemo
//
//  Created by Christian Otkjær on 13/03/17.
//  Copyright © 2017 Silverback IT. All rights reserved.
//

import UIKit
import Slider

class ViewController: UIViewController
{
    @IBOutlet weak var horizontalSlider: RoundedSlider? {didSet { horizontalSlider?.delegate = self } }
    
    @IBOutlet weak var verticalSlider: RoundedSlider? {didSet { verticalSlider?.delegate = self } }
}


// MARK: - <#comment#>

extension ViewController: SliderDelegate
{
    func slider(_ slider: Slider, didEndSlidingWithFinalValue finalValue: Float) {
        
    }
    
    func slider(_ slider: Slider, willAnimateWithAnimator animator: SliderAnimator)
    {
        guard let slider = slider as? RoundedSlider else { return }
    
        animator.animatedAlongside(animation:
            {
                let progress = CGFloat(animator.toValue)
                
                slider.thumbView.alpha = (1 + progress) / 2
                
                slider.thumbText = String(format: "%0.1f", progress)
                
        }, completion: nil)
    }
    
    func slider(_ slider: Slider, willBeginSlidingWithInitialValue initialValue: Float)
    {
        
    }
    
    func slider(_ slider: Slider, willEndSlidingWithProposedValue proposedValue: Float) -> Float?
    {
        return round(proposedValue * 10) / 10
    }
}

