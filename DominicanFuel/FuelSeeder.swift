//
//  FuelSeeder.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation
import CoreData
class FuelSeeder {
    
    class func seed(context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Fuel.entityName())
        var error: NSError? = nil
        var count = context.countForFetchRequest(request, error: &error)
        if error == nil && count == 0 {
            // Seed
            
            if let url = NSBundle.mainBundle().URLForResource("fuels", withExtension: "json") {
                if let data = NSData(contentsOfURL: url) {
                    var error: NSError? = nil
                    if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [[String: AnyObject]] {
                        
                        var formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        for dictionary in array {
                            if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: context) as? Fuel {
                                if let date = dictionary["published_at"] as? String {
                                    fuel.publishedAt = formatter.dateFromString(date)
                                    println("\(date) -- \(fuel.publishedAt)")
                                }
                                
                                if let type = dictionary["type"] as? String {
                                    fuel.type = type
                                }
                                
                                if let price = dictionary["price"] as? Double {
                                    fuel.price = price
                                }
                            }
                        }
                    }
                }
            }
            
        } else {
            println("Couldn't perform fetch request: \(error)")
        }
    }
    
    
}