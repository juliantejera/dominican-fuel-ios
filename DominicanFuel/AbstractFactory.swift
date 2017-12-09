//
//  AbstractFactory.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/25/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

protocol AbstractFactory {
    associatedtype T
    func create() -> T
}
