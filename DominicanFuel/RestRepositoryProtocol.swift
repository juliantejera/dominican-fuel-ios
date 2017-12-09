//
//  RestRepositoryProtocol.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/28/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

protocol RestRepositoryProtocol {
    
    associatedtype T: DictionaryMapping
    
    func find(_ id: String, callback: ((_ item: T?, _ error: NSError?) -> Void)?)
    func findAll(_ callback: ((_ items: [T]?, _ error: NSError?) -> Void)? )
    func create(_ item: T, callback: ((_ error: NSError?) -> Void)? )
    func update(_ id: String, item: T, callback: ((_ error: NSError?) -> Void)?)
    func delete(_ id: String, callback: ((_ error: NSError?) -> Void)?)
    
    func find(_ id: String, parameters: [String: String]?, callback: ((_ item: T?, _ error: NSError?) -> Void)?)
    func findAll(_ parameters: [String: String]?, callback: ((_ items: [T]?, _ error: NSError?) -> Void)? )
    func create(_ item: T, parameters: [String: String]?, callback: ((_ error: NSError?) -> Void)? )
    func update(_ id: String, item: T, parameters: [String: String]?, callback: ((_ error: NSError?) -> Void)?)
    func delete(_ id: String, parameters: [String: String]?, callback: ((_ error: NSError?) -> Void)?)
}
