//
//  APIRequest.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var clientID:String { get }
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    var clientID:String {
        return "MTYyNzk3NjF8MTU1NTYwNjUzNy4xMQ"
    }
    
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            // make optional return value and handle it everywhere this method is used.
            
            // TODO: "fatalError" is temporary and should be removed in release version
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        components.queryItems?.append(URLQueryItem(name: "client_id", value: clientID))
        
        guard let url = components.url else {
            // TODO: "fatalError" is temporary and should be removed in release version
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
