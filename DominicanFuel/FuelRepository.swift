//
//  FuelRepository.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelRepository: NSObject, NSURLSessionDelegate {
    let kAcceptHeaderKey = "Accept"
    let kContentTypeKey = "Content-Type"
    let kJsonContentType = "application/json; charset=utf-8"
  
    var endPoint: NSURL
    var session: NSURLSession?
    
    override init() {
        self.endPoint = NSURL(string: "http://localhost:3000/fuels")!
        
        super.init()
        var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    func findAll(parameters: [String: String]?, callback: (response: MultipleItemsNetworkResponse) -> Void) {
        var request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingParameters(parameters))
        request.HTTPMethod = "GET"
        println("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        var dataTask = self.session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            NetworkActivityIndicator.sharedInstance().removeConnection()
            println("Response: \(response)")
            
            if(connectionError != nil) {
                callback(response: .Failure(connectionError))
                return
            }
            
            // Serialize
            var jsonSerializationError: NSError?
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &jsonSerializationError) as? [[NSObject: AnyObject]] {
                callback(response: .Success(array))
            } else if let error = jsonSerializationError {
                callback(response: .Failure(error))
            }
        })

        dataTask?.resume()
    }
}