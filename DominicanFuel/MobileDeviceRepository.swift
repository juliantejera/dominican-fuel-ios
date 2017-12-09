//
//  MobileDeviceRepository.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/17/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class MobileDeviceRepository: NSObject, URLSessionDelegate {
    let kAcceptHeaderKey = "Accept"
    let kContentTypeKey = "Content-Type"
    let kJsonContentType = "application/json; charset=utf-8"
    
    var endPoint: URL
    var session: URLSession?
    
    override init() {
        self.endPoint = URL(string: "\(APIConfiguration.host())/mobile_devices")!
        
        super.init()
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func create(_ item: MobileDevice, callback: @escaping (_ response: SingleItemNetworkResponse) -> Void) {
        
        do {
            let request = NSMutableURLRequest(url: self.endPoint)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: item.toDictionary(), options: JSONSerialization.WritingOptions.prettyPrinted)
            
            print("Request: \(request)")
            NetworkActivityIndicator.sharedInstance().addConnection()
            let dataTask = session?.dataTask(with: request as URLRequest, completionHandler: { (data, response, connectionError) -> Void in
                NetworkActivityIndicator.sharedInstance().removeConnection()
                
                if let error = connectionError {
                    callback(.failure(error))
                    return
                }
                
                do {
                    if let data = data, let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [AnyHashable: Any] {
                        callback(.success(dictionary))
                    }
                    
                } catch let error as NSError {
                    callback(.failure(error))

                }

            })
            
            dataTask?.resume()
            
        } catch let error as NSError {
            callback(.failure(error))
        }
    }
}
