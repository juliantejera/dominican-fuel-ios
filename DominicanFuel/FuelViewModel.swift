//
//  FuelViewModel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/25/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelViewModel: Printable {
    var type = ""
    var price = ""
    var delta = ""
    var timespan = ""
    
    convenience init(fuel: Fuel, numberFormatter: NSNumberFormatter, dateFormatter: NSDateFormatter) {
        self.init()
        self.type = fuel.type
        self.price = numberFormatter.stringFromNumber(fuel.price) ?? ""
        self.delta = numberFormatter.stringFromNumber(fuel.delta) ?? ""
        if let date = fuel.publishedAt {
            let sixDaysInSeconds: NSTimeInterval = 60*60*24*6
            var effectiveUntil = NSDate(timeInterval: sixDaysInSeconds, sinceDate: date)
            self.timespan = "\(dateFormatter.stringFromDate(date)) - \(dateFormatter.stringFromDate(effectiveUntil))"
        }
    }
    
    var description: String {
        return "\(type): \(price) durante la semana de \(timespan) #CombustiblesDominicanos"
    }
}