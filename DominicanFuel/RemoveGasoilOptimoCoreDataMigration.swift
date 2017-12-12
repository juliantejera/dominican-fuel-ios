//
//  RemoveGasoilOptimoCoreDataMigration.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/11/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData

struct RemoveGasoilOptimoCoreDataMigration: CoreDataMigration {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func perform() {
        guard !UserDefaults.standard.bool(forKey: RemoveGasoilOptimoCoreDataMigration.name) else {
            return
        }
        
        let request = NSFetchRequest<FuelFilter>(entityName: FuelFilter.entityName())
        request.predicate = NSPredicate(format: "type = %@", "Gasoil Óptimo")
        request.fetchLimit = 1
        do {
            if let fuelFilter = try context.fetch(request).first {
                self.context.delete(fuelFilter)
                try context.save()
                UserDefaults.standard.set(true, forKey: RemoveGasoilOptimoCoreDataMigration.name)
            }
        } catch {
            
        }
    }
}
