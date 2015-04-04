//
//  FuelViewModel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/25/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelViewModel {
    var name = ""
    var price = ""
    var publishedAt = ""
    
    init(fuel: Fuel) {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        let dateFormatter = NSDateFormatter()
        self.name = fuel.type
        self.price = numberFormatter.stringFromNumber(fuel.price) ?? "$0.00"
        self.publishedAt = fuel.publishedAt != nil ? dateFormatter.stringFromDate(fuel.publishedAt!) : ""
    }
}