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
    
    class func kPublishedAt() -> String { return "published_at" }
    class func kType() -> String { return "fuel_type" }
    class func kPrice() -> String { return "price" }
    class func kDelta() -> String { return "delta" }
    
    func populateWithDictionary(dictionary: [String: AnyObject]) {
        if let date = dictionary[Fuel.kPublishedAt()] as? String {
            self.publishedAt = NSDateFormatter.sharedISO8601DateFormatter().dateFromString(date)
        }
        
        if let type = dictionary[Fuel.kType()] as? String {
            self.type = type
        }
        
        if let price = dictionary[Fuel.kPrice()] as? Double {
            self.price = price
        }
        
        if let delta = dictionary[Fuel.kDelta()] as? Double {
            self.delta = delta
        }
    }
}