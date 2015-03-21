//
//  RestRepositoryProtocol.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/28/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

protocol RestRepositoryProtocol {
    
    typealias T: DictionaryMapping
    
    func find(id: String, callback: ((item: T?, error: NSError?) -> Void)?)
    func findAll(callback: ((items: [T]?, error: NSError?) -> Void)? )
    func create(item: T, callback: ((error: NSError?) -> Void)? )
    func update(id: String, item: T, callback: ((error: NSError?) -> Void)?)
    func delete(id: String, callback: ((error: NSError?) -> Void)?)
    
    func find(id: String, parameters: [String: String]?, callback: ((item: T?, error: NSError?) -> Void)?)
    func findAll(parameters: [String: String]?, callback: ((items: [T]?, error: NSError?) -> Void)? )
    func create(item: T, parameters: [String: String]?, callback: ((error: NSError?) -> Void)? )
    func update(id: String, item: T, parameters: [String: String]?, callback: ((error: NSError?) -> Void)?)
    func delete(id: String, parameters: [String: String]?, callback: ((error: NSError?) -> Void)?)
}