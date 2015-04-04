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
        seedFuelFilters()
    }
    
    func seedFuelFilters() {
        if let context = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: FuelFilter.entityName())
            var error: NSError? = nil
            var count = context.countForFetchRequest(request, error: &error)
            if error == nil && count == 0 {
                let types = ["Gasolina Premium", "Gasolina Regular", "Gasoil Premium", "Gasoil Regular", "Gas Licuado de Petróleo (GLP)", "Kerosene", "Gas Natural", "Gas Natural Vehicular (GNV)"]
                
                for var i = 0; i < types.count; i++ {
                    if let fuelFilter = NSEntityDescription.insertNewObjectForEntityForName(FuelFilter.entityName(), inManagedObjectContext: context) as? FuelFilter {
                        fuelFilter.id = i + 1
                        fuelFilter.type = types[i]
                        fuelFilter.isSelected = true
                    }
                }
            }
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