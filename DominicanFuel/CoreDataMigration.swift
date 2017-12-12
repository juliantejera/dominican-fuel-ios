//
//  CoreDataMigration.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/11/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

protocol CoreDataMigration {
    func perform()
}

extension CoreDataMigration {
    
    static var name: String {
        return String(describing: self)
    }
    
}
