//
//  Date.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/9/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

extension NSDate {
    
    class func dateWithoutTime() {
        
        var date = NSDate()
    }
    
    class func lastSaturday(date: NSDate = NSDate()) -> NSDate {
        let saturday = 7
        
        if date.weekday == saturday {
            return date
        }
        
        return self.lastSaturday(date: date.yesterday)
    }
    
    var beginningOfDay: NSDate {
        var flags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    var endOfDay: NSDate {
        var flags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    var weekday: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.WeekdayCalendarUnit, fromDate: self)
    }
    
    var year: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.YearCalendarUnit, fromDate: self)
    }
    
    var month: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.MonthCalendarUnit, fromDate: self)
    }
    
    var day: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: self)
    }
    
    var hour: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.HourCalendarUnit, fromDate: self)
    }
    
    var minute: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.MinuteCalendarUnit, fromDate: self)
    }
    
    var second: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.SecondCalendarUnit, fromDate: self)
    }
    
    var yesterday: NSDate {
        return NSDate(timeInterval: -1*60*60*24, sinceDate: self)
    }
    
    var tomorrow: NSDate {
        return NSDate(timeInterval: 60*60*24, sinceDate: self)
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