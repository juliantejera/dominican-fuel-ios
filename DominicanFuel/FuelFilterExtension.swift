//
//  FuelFilterExtension.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/31/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData

extension FuelFilter {
    
    class func entityName() -> String {
        return "FuelFilter"
    }
    
    
    class func selectedFuelFilters(managedObjectContext: NSManagedObjectContext) -> [FuelFilter] {
        let request = NSFetchRequest(entityName: FuelFilter.entityName())
        request.predicate = NSPredicate(format: "isSelected == 1", argumentArray: nil)
        var error: NSError? = nil
        
        if let fuelFilters = managedObjectContext.executeFetchRequest(request, error: &error) as? [FuelFilter] {
            return fuelFilters
        } else {
            println("Error: \(error)")
        }
        
        return [FuelFilter]()
    }
}