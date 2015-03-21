//
//  NSURLExtension.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/29/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

extension NSURL {
    
    func URLByAppendingParameters(parameters: Dictionary<String, String>?) -> NSURL{
        
        if parameters == nil {
            return self
        }
        
        var array = Array<String>()
        for (key, value) in parameters! {
            array.append("\(key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))=\(value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))")
        }
        
        var queryString = array.reduce("", combine: { (x, y) -> String in
            return "\(x)&\(y)";
        })
    
        return NSURL(string: "\(self.absoluteString)?\(queryString)")!
    }
}