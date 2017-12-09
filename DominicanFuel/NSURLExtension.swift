//
//  NSURLExtension.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/29/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

extension URL {
    
    func URLByAppendingParameters(_ parameters: [String: String]?) -> URL{
        
        if parameters == nil {
            return self
        }
        
        var array = [String]()
        for (key, value) in parameters! {
            
            
            if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics), let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {
                array.append("\(escapedKey)=\(escapedValue)")
            }
        }
        
        let queryString = array.joined(separator: "&")
        
        return URL(string: "\(self.absoluteString)?\(queryString)")!
    }
}
