//
//  Fuel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData

@objc(Fuel)
class Fuel: NSManagedObject {
    
    @NSManaged var type: String
    @NSManaged var price: Double
    @NSManaged var delta: Double
    @NSManaged var publishedAt: Date?    
}
