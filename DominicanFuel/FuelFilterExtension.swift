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
    
    class func selectedFuelFilters(_ managedObjectContext: NSManagedObjectContext) -> [FuelFilter] {
        let request = NSFetchRequest<FuelFilter>(entityName: FuelFilter.entityName())
        request.predicate = NSPredicate(format: "isSelected == 1", argumentArray: nil)
        
        return (try? managedObjectContext.fetch(request)) ?? []
    }
}
