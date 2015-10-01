//
//  FuelViewModel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/25/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelViewModel: CustomStringConvertible {
    var type = ""
    var price = ""
    var delta = ""
    var timespan = ""
    
    convenience init(fuel: Fuel, numberFormatter: NSNumberFormatter, dateFormatter: NSDateFormatter) {
        self.init()
        self.type = fuel.type
        
        let percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        percentageFormatter.maximumFractionDigits = 2
        let percentualDelta = fuel.delta / (fuel.price - fuel.delta)
        if let delta = numberFormatter.stringFromNumber(fuel.delta), percentage = percentageFormatter.stringFromNumber(percentualDelta) where !percentualDelta.isNaN {
            self.delta = "\(delta) (\(percentage))"
        } else {
            self.delta = ""
        }
        
        self.price = numberFormatter.stringFromNumber(fuel.price) ?? ""

        if let date = fuel.publishedAt {
            let sixDaysInSeconds: NSTimeInterval = 60*60*24*6
            let effectiveUntil = NSDate(timeInterval: sixDaysInSeconds, sinceDate: date)
            self.timespan = "\(dateFormatter.stringFromDate(date)) - \(dateFormatter.stringFromDate(effectiveUntil))"
        }
    }
    
    var description: String {
        return "* \(type):\n - Precio: \(price)\n - Semana: \(timespan)\n#CombustiblesDominicanos"
    }
}