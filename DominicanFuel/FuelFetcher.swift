//
//  FuelFetcher.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 6/7/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelFetcher {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func mostRecentFuel() -> Fuel? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? managedObjectContext.fetch(request))?.first as? Fuel
    }
}
