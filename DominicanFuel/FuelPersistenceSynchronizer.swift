//
//  FuelPersistenceSynchronizer.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/9/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

struct FuelPersistenceSynchronizer {
    
    private let store: FuelCoreDataStore
    private let networkManager: FuelProxyNetworkManager
    
    init(store: FuelCoreDataStore, networkManager: FuelProxyNetworkManager) {
        self.store = store
        self.networkManager = networkManager
    }
    
    init(context: NSManagedObjectContext, client: NetworkClient = FuelNetworkClient()) {
        self.store = FuelCoreDataStore(context: context)
        self.networkManager = FuelProxyNetworkManager(client: client)
    }
    
    func seed() {
        if store.count == 0 {
            guard let url = Bundle.main.url(forResource: "fuels", withExtension: "json") else {
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.sharedISO8601DateFormatter())
                let proxies = try decoder.decode([FuelProxy].self, from: data)
                try store.persist(proxies: proxies)
                try self.store.context.save()
                synchronize()
            } catch let error {
                print(error)
            }
        } else {
            synchronize()
        }
        
    }
    
    func synchronize() {
        guard let publishedAt = store.last?.publishedAt else {
            return
        }
        
        networkManager.findAll(publishedAt: publishedAt) { (result) in
            switch result {
            case .success(let proxies):
                do {
                    try self.store.persist(proxies: proxies)
                    try self.store.context.save()
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }
    
    private func arrayFixture(name: String) -> [Any] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [Any] ?? []
        } catch {
            return []
        }
    }
}
