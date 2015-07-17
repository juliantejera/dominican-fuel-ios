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
            if let escapedKey = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), let escapedValue = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                array.append("\(escapedKey)=\(escapedValue)")
            }
        }
        
        let queryString = "&".join(array)
        
        return NSURL(string: "\(self.absoluteString!)?\(queryString)")!
    }
}