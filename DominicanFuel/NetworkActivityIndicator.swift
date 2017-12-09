//
//  NetworkActivityIndicator.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/28/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//
import UIKit

private let networkActivityIndicator = NetworkActivityIndicator()
class NetworkActivityIndicator: NSObject {
    
    fileprivate var count: Int = 0 {
        didSet {
            updateIndicator()
        }
    }
    
    class func sharedInstance() -> NetworkActivityIndicator {
        return networkActivityIndicator
    }
    
    func addConnection() {
        count += 1
    }
    
    func removeConnection() {
        count -= 1
    }
    
    func updateIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = (count > 0)
    }
}
