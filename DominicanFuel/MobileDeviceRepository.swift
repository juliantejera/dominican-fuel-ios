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
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    func create(item: MobileDevice, callback: (response: SingleItemNetworkResponse) -> Void) {
        
        do {
            let request = NSMutableURLRequest(URL: self.endPoint)
            request.HTTPMethod = "POST"
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(item.toDictionary(), options: NSJSONWritingOptions.PrettyPrinted)
            
            print("Request: \(request)")
            NetworkActivityIndicator.sharedInstance().addConnection()
            let dataTask = session?.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
                NetworkActivityIndicator.sharedInstance().removeConnection()
                print("Response: \(response)")
                
                if let error = connectionError {
                    callback(response: .Failure(error))
                    return
                }
                
                do {
                    if let data = data, let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [NSObject: AnyObject] {
                        callback(response: .Success(dictionary))
                    }
                    
                } catch let error as NSError {
                    callback(response: .Failure(error))

                }

            })
            
            dataTask?.resume()
            
        } catch let error as NSError {
            callback(response: .Failure(error))
        }
    }
}
