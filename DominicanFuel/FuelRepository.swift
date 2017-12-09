//
//  FuelRepository.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import Foundation

class FuelRepository: NSObject, URLSessionDelegate {
    let kAcceptHeaderKey = "Accept"
    let kContentTypeKey = "Content-Type"
    let kJsonContentType = "application/json; charset=utf-8"
  
    var endPoint: URL
    var session: URLSession?
    
    override init() {
        self.endPoint = URL(string: "\(APIConfiguration.host())/fuels")!
        
        super.init()
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [kAcceptHeaderKey: kJsonContentType, kContentTypeKey: kJsonContentType]
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func findAll(_ parameters: [String: String]?, callback: @escaping (_ response: MultipleItemsNetworkResponse) -> Void) {
        let request = NSMutableURLRequest(url: self.endPoint.URLByAppendingParameters(parameters))
        request.httpMethod = "GET"
        print("Request: \(request)")
        NetworkActivityIndicator.sharedInstance().addConnection()
        
        let dataTask = self.session?.dataTask(with: request as URLRequest, completionHandler: { (data, response, connectionError) -> Void in
            NetworkActivityIndicator.sharedInstance().removeConnection()
            print("Response: \(response)")
            
            if let error = connectionError {
                callback(MultipleItemsNetworkResponse.failure(error as NSError))
                return
            }
            
            do {
                if let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[AnyHashable: Any]] {
                    callback(.success(array))
                }
            } catch let error as NSError {
                callback(MultipleItemsNetworkResponse.failure(error))
            }
        })
        
        dataTask?.resume()
    }
}
