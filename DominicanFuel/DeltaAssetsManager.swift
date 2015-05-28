//
//  FuelDeltaResourceManager.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class DeltaAssetsManager: NSObject {
    lazy var upArrow = UIImage(named: "big_up_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var downArrow = UIImage(named: "big_down_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var equalSign = UIImage(named: "big_equal_sign")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var upArrowTintColor = UIColor.redColor()
    lazy var downArrowTintColor = UIColor.greenColor()
    lazy var equalSignTintColor = UIColor.orangeColor()
    
    func updateImageView(imageView: UIImageView, delta: Double) {
        imageView.tintColor = colorForDelta(delta)
        imageView.image = imageForDelta(delta)
    }
    
    func colorForDelta(delta: Double) -> UIColor {
        var color: UIColor
        if delta > 0 {
            color = upArrowTintColor
        } else if delta < 0 {
            color = downArrowTintColor
        } else {
            color = equalSignTintColor
        }
        return color
    }
    
    func imageForDelta(delta: Double) -> UIImage? {
        var image: UIImage?
        if delta > 0 {
            image = upArrow
        } else if delta < 0 {
            image = downArrow
        } else {
            image = equalSign
        }
        
        return image
    }
}
