//
//  Date.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/9/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

extension NSDate {
    
    class func lastSaturday(date: NSDate = NSDate()) -> NSDate {
        if date.weekday == Weekday.Saturday.rawValue {
            return date
        }
        
        return self.lastSaturday(date.yesterday)
    }
    
    var dateComponents: NSDateComponents {
        get {
            let flags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.TimeZone]
            return NSCalendar.currentCalendar().components(flags, fromDate: self)
        }
    }
    
    var beginningOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
        
    var weekday: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: self)
    }
    
    var year: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)
    }
    
    var month: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: self)
    }
    
    var day: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: self)
    }
    
    var hour: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: self)
    }
    
    var minute: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: self)
    }
    
    var second: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Second, fromDate: self)
    }
    
    var yesterday: NSDate {
        let oneDayInSeconds: NSTimeInterval = 60*60*24
        return NSDate(timeInterval: -oneDayInSeconds, sinceDate: self)
    }
    
    var tomorrow: NSDate {
        let oneDayInSeconds: NSTimeInterval = 60*60*24
        return NSDate(timeInterval: oneDayInSeconds, sinceDate: self)
    }
}

enum Weekday: Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}