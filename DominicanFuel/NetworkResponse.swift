//
//  NetworkResponse.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/25/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

enum MultipleItemsNetworkResponse {
    case failure(Error)
    case success([[AnyHashable: Any]])
}

enum SingleItemNetworkResponse {
    case failure(Error)
    case success([AnyHashable: Any])
}
