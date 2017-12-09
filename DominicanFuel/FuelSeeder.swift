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
    
    class func seed(_ context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                if let url = Bundle.main.url(forResource: "fuels", withExtension: "json") {
                    if let data = try? Data(contentsOf: url) {
                        
                        do {
                            if let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[AnyHashable: Any]] {
                                
                                
                                for dictionary in array {
                                    if let fuel = NSEntityDescription.insertNewObject(forEntityName: Fuel.entityName(), into: context) as? Fuel {
                                        fuel.populateWithDictionary(dictionary)
                                    }
                                }
                            }
                        } catch _ {
                            
                        }
                    }
                } else {
                    FuelSeeder.updateFuels(FuelRepository(), context: context)
                }
            }
        } catch let error {
            print("Couldn't perform fetch request: \(error.localizedDescription)")
        }

    }
    
    class func updateFuels(_ repository: FuelRepository, context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        request.fetchLimit = 1
        
        do {
            if let result = try context.fetch(request).first as? Fuel {
                if let date = result.publishedAt?.description {
                    let parameters = ["published_at": date]
                    
                    repository.findAll(parameters) { (response: MultipleItemsNetworkResponse) -> Void in
                        switch response {
                        case .failure(let error):
                            print("Error: \(error)")
                        case .success(let items):
                            for dictionary in items {
                                if !self.isDuplicateFuel(dictionary, context: context) {
                                    if let fuel = NSEntityDescription.insertNewObject(forEntityName: Fuel.entityName(), into: context) as? Fuel {
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
    
    
    class func isDuplicateFuel(_ dictionary: [AnyHashable: Any], context: NSManagedObjectContext) -> Bool {
        if let publishedAtString = dictionary[Fuel.kPublishedAt()] as? String,let publishedAt = DateFormatter.sharedISO8601DateFormatter().date(from: publishedAtString),let type = dictionary[Fuel.kType()] as? String {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
            request.predicate = NSPredicate(format: "publishedAt = %@ AND type = %@", publishedAt as CVarArg, type)
            let count = (try? context.count(for: request)) ?? 0
            return count > 0
        }
        return false
    }
}
