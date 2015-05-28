//
//  MobileDeviceRepository.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/17/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class MobileDeviceRepository: NSObject, NSURLSessionDelegate {
    let kAcceptHeaderKey = "Accept"
    let kContentTypeKey = "Content-Type"
    let kJsonContentType = "application/json; charset=utf-8"
    
    var endPoint: NSURL
    var session: NSURLSession?
    
    override init() {
        self.endPoint = NSURL(string: "\(APIConfiguration.host())/mobile_devices")!
        
        super.init()
        var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    func create(item: MobileDevice, callback: (response: SingleItemNetworkResponse) -> Void) {
        
        var jsonSerializationError: NSError?
        if let data = NSJSONSerialization.dataWithJSONObject(item.toDictionary(), options: NSJSONWritingOptions.PrettyPrinted, error: &jsonSerializationError) {
            
            var request = NSMutableURLRequest(URL: self.endPoint)
            request.HTTPMethod = "POST"
            request.HTTPBody = data
            
            println("Request: \(request)")
            NetworkActivityIndicator.sharedInstance().addConnection()
            var dataTask = session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
                NetworkActivityIndicator.sharedInstance().removeConnection()
                println("Response: \(response)")
                
                if let error = connectionError {
                    callback(response: .Failure(error))
                    return
                }
                
                var innerJsonSerializationError: NSError?
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &innerJsonSerializationError) as? [NSObject: AnyObject] {
                    callback(response: .Success(dictionary))
                } else if let error = innerJsonSerializationError {
                    callback(response: .Failure(error))
                }
                
            })
            
            dataTask?.resume()
            
        } else {
            callback(response: .Failure(jsonSerializationError!))
        }
    }
}
