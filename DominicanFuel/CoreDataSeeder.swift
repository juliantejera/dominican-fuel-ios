//
//  CoreDataSeeder.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/1/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class CoreDataSeeder {
    
    let document: UIManagedDocument
    
    init(document: UIManagedDocument) {
        self.document = document
    }
    
    func seed() {
        let context = document.managedObjectContext
        let fuelSynchronizer = FuelPersistenceSynchronizer(context: context)
        fuelSynchronizer.seed()
        FuelFilterSeeder.seed(context)
    }
}
