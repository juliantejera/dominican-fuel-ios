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
                    
                    if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [[NSObject: AnyObject]] {
                        
                        for dictionary in array {
                            if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: context) as? Fuel {
                                fuel.populateWithDictionary(dictionary)
                            }
                        }
                    }
                    
                    FuelSeeder.updateFuels(FuelRepository(), context: context)
                }
            }
            
        } else if error != nil {
            println("Couldn't perform fetch request: \(error)")
        } else if count > 0 {
            FuelSeeder.updateFuels(FuelRepository(), context: context)
        }
    }
    
    class func updateFuels(repository: FuelRepository, context: NSManagedObjectContext) {
        var request = NSFetchRequest(entityName: Fuel.entityName())
        var error: NSError? = nil
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        request.fetchLimit = 1
        
        if let result = context.executeFetchRequest(request, error: &error)?.first as? Fuel {
            if let date = result.publishedAt?.description {
                let parameters = ["published_at": date]
                
                repository.findAll(parameters) { (response: NetworkResponse) -> Void in
                    switch response {
                    case .Failure(let error):
                        println("Error: \(error)")
                    case .Success(let items):
                        for dictionary in items {
                            if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: context) as? Fuel {
                                fuel.populateWithDictionary(dictionary)
                            }
                        }
                    }
                }
            }
            
        }
        
        
    }
}