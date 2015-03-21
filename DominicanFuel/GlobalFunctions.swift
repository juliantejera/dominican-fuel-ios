//
//  GlobalFunctions.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

public func println(object: Any) {
    #if DEBUG
        Swift.println(object)
    #endif
}