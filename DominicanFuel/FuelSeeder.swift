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
        let count = context.countForFetchRequest(request, error: &error)
        if error == nil && count == 0 {
            // Seed
            
            if let url = NSBundle.mainBundle().URLForResource("fuels", withExtension: "json") {
                if let data = NSData(contentsOfURL: url) {
                    
                    do {
                        if let array = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[NSObject: AnyObject]] {
                            
                            
                            for dictionary in array {
                                if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: context) as? Fuel {
                                    fuel.populateWithDictionary(dictionary)
                                }
                            }
                        }
                    } catch _ {
                        
                    }
                }
            }
            
        } else if error != nil {
            print("Couldn't perform fetch request: \(error)")
        } else if count > 0 {
            FuelSeeder.updateFuels(FuelRepository(), context: context)
        }
    }
    
    class func updateFuels(repository: FuelRepository, context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Fuel.entityName())
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        request.fetchLimit = 1
        
        do {
            if let result = try context.executeFetchRequest(request).first as? Fuel {
                if let date = result.publishedAt?.description {
                    let parameters = ["published_at": date]
                    
                    repository.findAll(parameters) { (response: MultipleItemsNetworkResponse) -> Void in
                        switch response {
                        case .Failure(let error):
                            print("Error: \(error)")
                        case .Success(let items):
                            for dictionary in items {
                                if !self.isDuplicateFuel(dictionary, context: context) {
                                    if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: context) as? Fuel {
                                        fuel.populateWithDictionary(dictionary)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        } catch _ {
            
        }
    }
    
    
    class func isDuplicateFuel(dictionary: [NSObject: AnyObject], context: NSManagedObjectContext) -> Bool {
        if let publishedAtString = dictionary[Fuel.kPublishedAt()] as? String,let publishedAt = NSDateFormatter.sharedISO8601DateFormatter().dateFromString(publishedAtString),let type = dictionary[Fuel.kType()] as? String {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            request.predicate = NSPredicate(format: "publishedAt = %@ AND type = %@", publishedAt, type)
            let count = context.countForFetchRequest(request, error: nil)
            return count > 0
        }
        return false
    }
}