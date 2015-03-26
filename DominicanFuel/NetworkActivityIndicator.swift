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
    
    private var count: Int = 0 {
        didSet {
            updateIndicator()
        }
    }
    
    class func sharedInstance() -> NetworkActivityIndicator {
        return networkActivityIndicator
    }
    
    func addConnection() {
        count++
    }
    
    func removeConnection() {
        count--
    }
    
    func updateIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = (count > 0)
    }
}