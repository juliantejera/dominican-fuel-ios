//
//  FuelFilterSeeder.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData
class FuelFilterSeeder {
    
    class func seed(context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: FuelFilter.entityName())
        var error: NSError? = nil
        let count = context.countForFetchRequest(request, error: &error)
        if error == nil && count == 0 {
            let types = ["Gasolina Premium", "Gasolina Regular", "Gasoil Óptimo","Gasoil Premium", "Gasoil Regular", "Gas Licuado de Petróleo (GLP)", "Kerosene", "Gas Natural Vehicular (GNV)"]
            
            for var i = 0; i < types.count; i++ {
                if let fuelFilter = NSEntityDescription.insertNewObjectForEntityForName(FuelFilter.entityName(), inManagedObjectContext: context) as? FuelFilter {
                    fuelFilter.id = i + 1
                    fuelFilter.type = types[i]
                    fuelFilter.isSelected = true
                }
            }
        } else if error != nil {
            print("Couldn't perform fetch request: \(error)")
        }
    }
    
}