//
//  FuelProxy.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/9/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

struct FuelProxy: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type = "fuel_type"
        case price = "price"
        case delta = "delta"
        case publishedAt = "published_at"
    }
    
    let type: String
    let price: Double
    let delta: Double
    let publishedAt: Date
}
