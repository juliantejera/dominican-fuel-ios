//
//  FuelDetailsTableViewHeaderImageView.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelDetailsTableViewHeaderImageView: UIImageView {

    private lazy var upArrow = UIImage(named: "big_up_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var downArrow = UIImage(named: "big_down_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var equalSign = UIImage(named: "big_equal_sign")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var upArrowTintColor = UIColor.redColor()
    private lazy var downArrowTintColor = UIColor.greenColor()
    private lazy var equalSignTintColor = UIColor.orangeColor()
    
    
    func update(delta: Double) {
        var selectedBorderColor: CGColor
        if delta > 0 {
            selectedBorderColor = upArrowTintColor.CGColor
            self.tintColor = upArrowTintColor
            self.image = upArrow
        } else if delta < 0 {
            selectedBorderColor = downArrowTintColor.CGColor
            self.tintColor = downArrowTintColor
            self.image = downArrow
        } else {
            selectedBorderColor = equalSignTintColor.CGColor
            self.tintColor = equalSignTintColor
            self.image = equalSign
        }
        
        var animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.clearColor().CGColor
        animation.toValue = selectedBorderColor
        animation.duration = 3.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.layer.addAnimation(animation, forKey: "borderColor")
        self.layer.borderColor = selectedBorderColor
    }
}
