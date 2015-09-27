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
        self.endPoint = NSURL(string: "\(APIConfiguration.host())/fuels")!
        
        super.init()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    func findAll(parameters: [String: String]?, callback: (response: MultipleItemsNetworkResponse) -> Void) {
        let request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingParameters(parameters))
        request.HTTPMethod = "GET"
        print("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        
        let dataTask = self.session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            NetworkActivityIndicator.sharedInstance().removeConnection()
            print("Response: \(response)")
            
            if let error = connectionError {
                callback(response: MultipleItemsNetworkResponse.Failure(error))
                return
            }
            
            do {
                if let array = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as? [[NSObject: AnyObject]] {
                    callback(response: .Success(array))
                }
            } catch let error as NSError {
                callback(response: MultipleItemsNetworkResponse.Failure(error))
            }
        })
        
        dataTask?.resume()
    }
}