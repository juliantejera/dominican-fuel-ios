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
    
    convenience init(fuel: Fuel, numberFormatter: NumberFormatter, dateFormatter: DateFormatter) {
        self.init()
        self.type = fuel.type
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = NumberFormatter.Style.percent
        percentageFormatter.maximumFractionDigits = 2
        let percentualDelta = fuel.delta / (fuel.price - fuel.delta)
        if let delta = numberFormatter.string(from: NSNumber(value: fuel.delta)), let percentage = percentageFormatter.string(from: NSNumber(value: percentualDelta)), !percentualDelta.isNaN {
            self.delta = "\(delta) (\(percentage))"
        } else {
            self.delta = ""
        }
        
        self.price = numberFormatter.string(from: NSNumber(value: fuel.price)) ?? ""

        if let date = fuel.publishedAt {
            let sixDaysInSeconds: TimeInterval = 60*60*24*6
            let effectiveUntil = Date(timeInterval: sixDaysInSeconds, since: date as Date)
            self.timespan = "\(dateFormatter.string(from: date as Date)) - \(dateFormatter.string(from: effectiveUntil))"
        }
    }
    
    var description: String {
        return "* \(type):\n - Precio: \(price)\n - Semana: \(timespan)\n#CombustiblesDominicanos"
    }
}
