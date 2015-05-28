//
//  FuelCellFactory.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelTableViewCellFactory: NSObject {
    
    lazy var fuelFactory = FuelViewModelFactory()
    
    private lazy var upArrow = UIImage(named: "up_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var downArrow = UIImage(named: "down_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var equalSign = UIImage(named: "equal_sign")?.imageWithRenderingMode(.AlwaysTemplate)
    private lazy var upArrowTintColor = UIColor.redColor()
    private lazy var downArrowTintColor = UIColor.greenColor()
    private lazy var equalSignTintColor = UIColor.orangeColor()
    
    func configureCell(cell: FuelTableViewCell, forFuel fuel: Fuel)  {
        let fuelViewModel = fuelFactory.mapToViewModel(fuel)
        cell.viewModel = fuelViewModel
        if let imageView = cell.signImageView {
            updateImageView(imageView, delta: fuel.delta)
        }
    }
    
    private func updateImageView(imageView: UIImageView, delta: Double) {
        if delta > 0 {
            imageView.tintColor = upArrowTintColor
            imageView.image = upArrow
        } else if delta < 0 {
            imageView.tintColor = downArrowTintColor
            imageView.image = downArrow
        } else {
            imageView.tintColor = equalSignTintColor
            imageView.image = equalSign
        }
    }
}
