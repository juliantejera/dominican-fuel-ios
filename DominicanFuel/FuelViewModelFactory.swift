//
//  FuelViewModelFactory.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelViewModelFactory {
    lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        return formatter
        }()
    
    lazy var numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        return formatter
        }()
    
    func mapToViewModel(_ fuel: Fuel) -> FuelViewModel {
        return FuelViewModel(fuel: fuel, numberFormatter: numberFormatter, dateFormatter: dateFormatter)
    }
}
