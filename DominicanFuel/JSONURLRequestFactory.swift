//
//  JSONURLRequestFactory.swift
//  Dream
//
//  Created by Julian Tejera-Frias on 9/22/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum JSONURLRequestFactoryError: Error {
    case invalidUrl
}

struct JSONURLRequestFactory {
    
    func create(url: URL, httpMethod: HttpMethod, parameters: [String: Any]? = nil, httpBody: Data? = nil, httpHeaders: [String: String]? = nil) throws -> URLRequest {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = parameters {
            components?.queryItems = URLQueryItemFactory().create(parameters: parameters)
        }
        guard let componentsUrl = components?.url else {
            throw JSONURLRequestFactoryError.invalidUrl
        }
        var request = URLRequest(url: componentsUrl)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.allHTTPHeaderFields?.add(dictionary: jsonHeaders)
        if let httpHeaders = httpHeaders {
            request.allHTTPHeaderFields?.add(dictionary: httpHeaders)
        }
        
        return request
    }
    
    private let jsonHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
}
