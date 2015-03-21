//
//  ApplicationClient.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

private let appClient = AppClient()
class AppClient {
    
    let baseURL = NSURL(string: "http://localhost:3000")!
    var fuelRepository: RestRepository<Fuel>
    init() {
        fuelRepository = RestRepository<Fuel>(endPoint: baseURL.URLByAppendingPathComponent("/fuels"))
    }
    
    class func sharedInstance() -> AppClient {
        return appClient
    }
}