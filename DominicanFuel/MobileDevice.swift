//
//  MobileDevice.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/17/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class MobileDevice {
    var pushNotificationToken: String
    var operatingSystem = 0
    
    init(pushNotificationToken: String) {
        self.pushNotificationToken = pushNotificationToken
    }
    
    func toDictionary() -> [NSObject: AnyObject] {
        var dictionary = [NSObject: AnyObject]()
        dictionary[MobileDevice.kPushNotificationToken()] = self.pushNotificationToken
        dictionary[MobileDevice.kOperatingSystem()] = self.operatingSystem
        return dictionary
    }
    
    class func kPushNotificationToken() -> String { return "push_notification_token" }
    class func kOperatingSystem() -> String { return "operating_system" }
}
