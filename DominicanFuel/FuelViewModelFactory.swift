//
//  FuelViewModelFactory.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelViewModelFactory {
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
        }()
    
    lazy var numberFormatter: NSNumberFormatter = {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter
        }()
    
    func mapToViewModel(fuel: Fuel) -> FuelViewModel {
        return FuelViewModel(fuel: fuel, numberFormatter: numberFormatter, dateFormatter: dateFormatter)
    }
}