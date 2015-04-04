//
//  CoreDataSeeder.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/1/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class CoreDataSeeder: ManagedDocumentCoordinatorDelegate {
    
    var document: UIManagedDocument?
    
    init() {
        var coordinator = DominicanFuelManagedDocumentCoordinator()
        coordinator.delegate = self
        coordinator.setupDocument()
    }
    
    func seed() {
        if let context = document?.managedObjectContext {
            FuelSeeder.seed(context)
            FuelFilterSeeder.seed(context)
        }
    }
    
    // MARK: - Managed Document Coordinator Delegate
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        seed()
        self.document = nil
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        println("Error: \(error)")
    }
}