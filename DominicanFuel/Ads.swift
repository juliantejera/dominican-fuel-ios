//
//  Ads.swift
//  DominicanFuel
//
//  Created by Julian Tejera-Frias on 12/11/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

enum Ads: String {
    case admob = "ca-app-pub-3743373903826064/5760698435"
}

enum InterstitialAdEvent: String {
    case fuelDetails = "fuel_details_interstitial"
    
    var tracker: InterstitialAdTracker {
        return InterstitialAdTracker(key: rawValue, attemptCount: 5)
    }
}

struct InterstitialAdTracker {
    
    let key: String
    let attemptCount: Int
    
    var shouldShowAd: Bool {
        return UserDefaults.standard.integer(forKey: key) % attemptCount == 0
    }
    
    func increaseCounter() {
        let value = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(value + 1, forKey: key)
    }
    
}
