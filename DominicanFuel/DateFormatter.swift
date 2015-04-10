//
//  Date.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/4/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation


private let iso8601DateFormatterInstance = NSDateFormatter()
extension NSDateFormatter {
    class func sharedISO8601DateFormatter() -> NSDateFormatter {
        iso8601DateFormatterInstance.dateFormat = "yyyy-MM-dd"
        return iso8601DateFormatterInstance
    }
}