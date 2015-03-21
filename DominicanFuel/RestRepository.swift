//
//  RestRepository.swift
//  PetAlert
//
//  Created by Julian Tejera on 12/28/14.
//  Copyright (c) 2014 Julian Tejera. All rights reserved.
//

import Foundation

class RestRepository<T: DictionaryMapping>: NSObject, RestRepositoryProtocol, NSURLSessionDelegate {
    
    let kAcceptHeaderKey = "Accept"
    let kContentTypeKey = "Content-Type"
    let kJsonContentType = "application/json; charset=utf-8"
    let kXmlContentType = "application/xml; charset=utf-8"
    let kFormURLEncodedContentType = "application/x-www-form-urlencoded; charset=utf-8"
    
    
    var endPoint: NSURL
    var session: NSURLSession?
    
    init(endPoint: NSURL) {
        self.endPoint = endPoint
        
        super.init()
        var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    
    // MARK: RestRepositoryProtocol
    
    func find(id: String, parameters: [String: String]?, callback: ((item: T?, error: NSError?) -> Void)?) {
        
        var url = self.endPoint.URLByAppendingPathComponent(id).URLByAppendingParameters(parameters)
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        processGetRequest(request, callback: callback)
    }
    
    func findAll(parameters: [String: String]?, callback: ((items: [T]?, error: NSError?) -> Void)? ) {
        
        var request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingParameters(parameters))
        request.HTTPMethod = "GET"
        processGetRequest(request, callback: callback)
    }
    
    func create(item: T, parameters: [String: String]?, callback: ((error: NSError?) -> Void)? ) {
        
        var jsonSerializationError: NSError?
        if let data = NSJSONSerialization.dataWithJSONObject(item.toDictionary(), options: NSJSONWritingOptions.PrettyPrinted, error: &jsonSerializationError) {
            
            var request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingParameters(parameters))
            request.HTTPMethod = "POST"
            request.HTTPBody = data
            processNonGetRequest(request, callback: callback)
            
        } else {
            callback?(error: jsonSerializationError)
        }
    }
    
    func update(id: String, item: T, parameters: [String: String]?, callback: ((error: NSError?) -> Void)?) {
        
        var jsonSerializationError: NSError?
        if let data = NSJSONSerialization.dataWithJSONObject(item.toDictionary(), options: NSJSONWritingOptions.PrettyPrinted, error: &jsonSerializationError) {
            
            var request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingPathComponent(id).URLByAppendingParameters(parameters))
            request.HTTPMethod = "PUT"
            request.HTTPBody = data
            processNonGetRequest(request, callback: callback)
            
        } else {
            callback?(error: jsonSerializationError)
        }
        
    }
    
    func delete(id: String, parameters: [String: String]?, callback: ((error: NSError?) -> Void)?) {
        var request = NSMutableURLRequest(URL: self.endPoint.URLByAppendingPathComponent(id).URLByAppendingParameters(parameters))
        request.HTTPMethod = "DELETE"
        processNonGetRequest(request, callback: callback)
    }
    
    
    
    func find(id: String, callback: ((item: T?, error: NSError?) -> Void)? ) {
        find(id, parameters: nil, callback: callback)
    }
    func findAll(callback: ((items: [T]?, error: NSError?) -> Void)? ) {
        findAll(nil, callback: callback)
    }
    func create(item: T, callback: ((error: NSError?) -> Void)? ) {
        create(item, parameters: nil, callback: callback)
    }
    func update(id: String, item: T, callback: ((error: NSError?) -> Void)?) {
        update(id, item: item, parameters: nil, callback: callback)
    }
    func delete(id: String, callback: ((error: NSError?) -> Void)? ) {
        delete(id, parameters: nil, callback: callback)
    }
    
    
    // MARK: Private methods
    
    
    private func processGetRequest(request: NSMutableURLRequest, callback: ((item: T?, error: NSError?) -> Void)?) {
        
        println("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        var dataTask = self.session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            
            NetworkActivityIndicator.sharedInstance().removeConnection()
            println("Response: \(response)")
            
            if(connectionError != nil) {
                callback?(item: nil, error: connectionError)
                return
            }
            
            // Serialize
            var jsonSerializationError: NSError?
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonSerializationError) as? [NSObject: AnyObject] {
                callback?(item: T(dictionary: dictionary), error: nil)
            } else {
                callback?(item: nil, error: jsonSerializationError)
            }
        })
        
        dataTask?.resume()
        
    }
    
    private func processGetRequest(request: NSMutableURLRequest, callback: ((items: [T]?, error: NSError?) -> Void)?) {
        
        println("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        var dataTask = self.session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            NetworkActivityIndicator.sharedInstance().removeConnection()
            println("Response: \(response)")
            
            if(connectionError != nil) {
                callback?(items: nil, error: connectionError)
                return
            }
            
            // Serialize
            var jsonSerializationError: NSError?
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &jsonSerializationError) as? [[NSObject: AnyObject]] {
                callback?(items: array.map { T(dictionary: $0) }, error: nil)
            } else {
                callback?(items: nil, error: jsonSerializationError)
            }
            
        })
        
        dataTask?.resume()
    }
    
    private func processNonGetRequest(request: NSMutableURLRequest, callback: ((error: NSError?) -> Void)?) {
        println("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        var dataTask = session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            NetworkActivityIndicator.sharedInstance().removeConnection()
            println("Response: \(response)")
            callback?(error: connectionError)
        })
        
        dataTask?.resume()
    }
    

}