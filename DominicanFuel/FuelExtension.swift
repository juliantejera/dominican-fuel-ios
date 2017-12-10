//
//  FuelExtension.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

extension Fuel {
    
    class func entityName() -> String {
        return "Fuel"
    }
    
    static func createFetchRequest() -> NSFetchRequest<Fuel> {
        return NSFetchRequest<Fuel>(entityName: Fuel.entityName())
    }
    
    func update(proxy: FuelProxy) {
        self.publishedAt = proxy.publishedAt
        self.type = proxy.type
        self.price = proxy.price
        self.delta = proxy.delta
    }

    func historicFuel(at date: Date) -> Fuel? {
        let request = NSFetchRequest<Fuel>(entityName: Fuel.entityName())
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "(publishedAt >= %@ AND publishedAt < %@) AND type = %@", argumentArray: [date.beginningOfDay, date.tomorrow.beginningOfDay, self.type])
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? self.managedObjectContext?.fetch(request))??.first
    }
}
