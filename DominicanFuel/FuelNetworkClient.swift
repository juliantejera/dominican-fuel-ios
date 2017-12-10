//
//  FuelNetworkClient.swift
//  Dream
//
//  Created by Julian Tejera-Frias on 4/13/17.
//  Copyright © 2017 Julian Tejera. All rights reserved.
//

import Foundation

enum FuelNetworkClientError: Error {
    case unparsableModel
}

class FuelNetworkClient: NetworkClient {
    var basePath: String {
        return baseUrl.absoluteString
    }

    let baseUrl = URL(string: "http://www.combustiblesdominicanos.com/")!
    private let decoder: JSONDecoder
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .formatted(.sharedISO8601DateFormatter())
    }
    
    func request(method: HttpMethod, path: String, parameters: [String : Any]? = nil, httpBody: Data? = nil, callback: @escaping (NetworkClientResult<Data>) -> Void) {
        
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return
        }
        
        do {
            let request = try JSONURLRequestFactory().create(url: url, httpMethod: method, parameters: parameters)
            let task = session.task(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        callback(.success(data))
                    } else if let error = error {
                        callback(.failure([error.localizedDescription]))
                    }
                }
                
            }
            
            task.resume()
        } catch let error {
            callback(.failure([error.localizedDescription]))
        }

    }
    
    func request<T>(method: HttpMethod, path: String, parameters: [String : Any]? = nil, httpBody: Data? = nil, callback: @escaping (NetworkClientResult<T>) -> Void) where T : Decodable, T : Encodable {
        request(method: method, path: path, parameters: parameters, httpBody: httpBody) { (dataResult) in
            switch dataResult {
            case .success(let data):
                do {
                    let codable = try self.decoder.decode(T.self, from: data)
                    callback(.success(codable))
                } catch let error {
                    callback(.failure([error.localizedDescription]))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

}
