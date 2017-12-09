//
//  FuelDetailsTableViewHeaderImageView.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelDetailsTableViewHeaderImageView: UIImageView {

    lazy var deltaAssetsManager = DeltaAssetsManager()
    
    func update(_ delta: Double) {
        deltaAssetsManager.updateImageView(self, delta: delta)
        animateBorderColor(deltaAssetsManager.colorForDelta(delta).cgColor)
    }
    
    func animateBorderColor(_ color: CGColor) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.clear.cgColor
        animation.toValue = color
        animation.duration = 2.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.layer.add(animation, forKey: "borderColor")
        self.layer.borderColor = color
    }
}
