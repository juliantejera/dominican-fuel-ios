//
//  Fuel.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class Fuel: DictionaryMapping {
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
    
    required init(dictionary: [NSObject: AnyObject]) {
        if let id = dictionary[Fuel.kId()] as? Int {
            self.id = id
        }
        
        if let name = dictionary[Fuel.kName()] as? String {
            self.name = name
        }
        
        if let price = dictionary[Fuel.kPrice()] as? Double {
            self.price = price
        }
        
        if let publishedAt = dictionary[Fuel.kPrice()] as? String {
            self.publishedAt = NSDateFormatter().dateFromString(publishedAt)
        }
    }
    
    func toDictionary() -> [NSObject: AnyObject] {
        var dictionary = [String: AnyObject]()
        dictionary[Fuel.kId()] = id
        dictionary[Fuel.kName()] = name
        dictionary[Fuel.kPrice()] = price
        dictionary[Fuel.kPublishedAt()] = publishedAt
        return dictionary
    }
    
    class func kId() -> String { return "id" }
    class func kName() -> String { return "name" }
    class func kPrice() -> String { return "price" }
    class func kPublishedAt() -> String { return "publishedAt" }
    
    class func fuelNames() -> [String] {
        return ["Gasolina Premium", "Gasolina Regular", "Gasoil Premium", "Gasoil Regular", "Kerosene", "Gas Natural", "Gas Licuado de Petróleo (GLP)", "Gas Natural Vehicular (GNV)"]
    }
}