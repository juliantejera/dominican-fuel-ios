//
//  FuelDeltaResourceManager.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class DeltaAssetsManager: NSObject {
    lazy var upArrow: UIImage! = UIImage(named: "big_up_arrow")?.withRenderingMode(.alwaysTemplate)
    lazy var downArrow: UIImage! = UIImage(named: "big_down_arrow")?.withRenderingMode(.alwaysTemplate)
    lazy var equalSign: UIImage! = UIImage(named: "big_equal_sign")?.withRenderingMode(.alwaysTemplate)
    lazy var upArrowTintColor = UIColor.red
    lazy var downArrowTintColor = UIColor.green
    lazy var equalSignTintColor = UIColor.orange
    
    func updateImageView(_ imageView: UIImageView, delta: Double) {
        imageView.tintColor = colorForDelta(delta)
        imageView.image = imageForDelta(delta)
    }
    
    func colorForDelta(_ delta: Double) -> UIColor {
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
    
    func imageForDelta(_ delta: Double) -> UIImage? {
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
