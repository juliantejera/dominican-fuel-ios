//
//  NSURLExtension.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/29/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

extension NSURL {
    
    func URLByAppendingParameters(parameters: [String: String]?) -> NSURL{
        
        if parameters == nil {
            return self
        }
        
        var array = [String]()
        for (key, value) in parameters! {
            
            
            if let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()), let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) {
                array.append("\(escapedKey)=\(escapedValue)")
            }
        }
        
        let queryString = array.joinWithSeparator("&")
        
        return NSURL(string: "\(self.absoluteString)?\(queryString)")!
    }
}