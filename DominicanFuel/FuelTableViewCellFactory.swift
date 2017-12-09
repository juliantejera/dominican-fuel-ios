//
//  FuelCellFactory.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/27/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelTableViewCellFactory: NSObject {
    
    lazy var deltaAssetsManager = DeltaAssetsManager()
    lazy var fuelFactory = FuelViewModelFactory()
    

    func configureCell(_ cell: FuelTableViewCell, forFuel fuel: Fuel)  {
        let fuelViewModel = fuelFactory.mapToViewModel(fuel)
        cell.viewModel = fuelViewModel
        if let imageView = cell.signImageView {
            deltaAssetsManager.updateImageView(imageView, delta: fuel.delta)
        }
    }

}
