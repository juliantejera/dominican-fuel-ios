//
//  Fuel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class Fuel {
    var id = 0
    var name = ""
    var price = 0.0
    var publishedAt: NSDate?
    
    init(id: Int, name: String, price: Double, publishedAt: NSDate? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.publishedAt = publishedAt
    }
}