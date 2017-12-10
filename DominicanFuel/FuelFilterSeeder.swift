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
    
    class func seed(_ context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: FuelFilter.entityName())
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                let types = [
                    "Gasolina Premium",
                    "Gasolina Regular",
                    "Gasoil Óptimo",
                    "Gasoil Premium",
                    "Gasoil Regular",
                    "Gas Licuado de Petróleo (GLP)",
                    "Kerosene",
                    "Gas Natural Vehicular (GNV)"
                ]
                
                for i in 0 ..< types.count {
                    if let fuelFilter = NSEntityDescription.insertNewObject(forEntityName: FuelFilter.entityName(), into: context) as? FuelFilter {
                        fuelFilter.id = NSNumber(value: i + 1)
                        fuelFilter.type = types[i]
                        fuelFilter.isSelected = true
                    }
                }

            }
        } catch let error {
            print("Couldn't perform fetch request: \(error)")
        }

    }
    
}
