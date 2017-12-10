//
//  FuelCoreDataStore.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/9/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData

struct FuelCoreDataStore {
    
    let context: NSManagedObjectContext
    
    var count: Int {
        do {
            return try context.count(for: Fuel.createFetchRequest())
        } catch {
            return 0
        }
    }
    
    var last: Fuel? {
        let request = Fuel.createFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first
    }
    
    func persist(proxies: [FuelProxy]) throws {
        try proxies.forEach {
            try persist(proxy: $0)
        }
    }
    
    func persist(proxy: FuelProxy) throws {
        let persisted = try isPersisted(proxy: proxy)
        if !persisted {
            let fuel = Fuel(context: context)
            fuel.update(proxy: proxy)
        }
    }

    private func isPersisted(proxy: FuelProxy) throws -> Bool {
        let request = Fuel.createFetchRequest()
        request.predicate = NSPredicate(format: "publishedAt = %@ AND type = %@", proxy.publishedAt as NSDate, proxy.type)
        return try context.count(for: request) > 0
    }
}
