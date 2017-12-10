//
//  FuelNetworkManager.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/9/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

struct FuelProxyNetworkManager: NetworkManager {
    
    let client: NetworkClient
    let relativePath: String
    
    init(client: NetworkClient = FuelNetworkClient()) {
        self.client = client
        self.relativePath = "fuels"
    }
    
    func findAll(publishedAt: Date, callback: @escaping (NetworkClientResult<[FuelProxy]>) -> Void) {
        let parameters = ["published_at": publishedAt]

        client.request(method: .get, path: path, parameters: parameters, httpBody: nil) { (result: NetworkClientResult<[FuelProxy]>) in
            callback(result)
        }
        
    }
}
