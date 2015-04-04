//
//  FuelSeeder.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData
class FuelSeeder {
    
    class func seed(context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Fuel.entityName())
        var error: NSError? = nil
        var count = context.countForFetchRequest(request, error: &error)
        if error == nil && count == 0 {
            // Seed
        } else {
            println("Couldn't perform fetch request: \(error)")
        }
    }
    
}