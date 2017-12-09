//
//  Date.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/9/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

extension Date {
    
    static func lastSaturday(_ date: Date = Date()) -> Date {
        if date.weekday == Weekday.saturday.rawValue {
            return date
        }
        
        return self.lastSaturday(date.yesterday)
    }
    
    var dateComponents: DateComponents {
        get {
            let flags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.timeZone]
            return (Calendar.current as NSCalendar).components(flags, from: self)
        }
    }
    
    var beginningOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
        
    var weekday: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.weekday, from: self)
    }
    
    var year: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.year, from: self)
    }
    
    var month: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.month, from: self)
    }
    
    var day: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.day, from: self)
    }
    
    var hour: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.hour, from: self)
    }
    
    var minute: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.minute, from: self)
    }
    
    var second: Int {
        return (Calendar.current as NSCalendar).component(NSCalendar.Unit.second, from: self)
    }
    
    var yesterday: Date {
        let oneDayInSeconds: TimeInterval = 60*60*24
        return Date(timeInterval: -oneDayInSeconds, since: self)
    }
    
    var tomorrow: Date {
        let oneDayInSeconds: TimeInterval = 60*60*24
        return Date(timeInterval: oneDayInSeconds, since: self)
    }
}

enum Weekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}
