//
//  FuelFilter.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/31/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData

@objc(FuelFilter)
class FuelFilter: NSManagedObject {

    @NSManaged var id: Int
    @NSManaged var type: String
    @NSManaged var isSelected: Bool
    
}
