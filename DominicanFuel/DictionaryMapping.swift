//
//  DictionaryMapping.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/28/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//
import Foundation

protocol DictionaryMapping {
    init(dictionary: [AnyHashable: Any])
    func toDictionary() -> [AnyHashable: Any]
}
