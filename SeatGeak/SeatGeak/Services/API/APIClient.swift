//
//  APIClient.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum APIError: Error {
    case cannotParse
    case invalidResponse
    case invalidClientID
    case noInternet
    case responseError(code:Int)
}

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

typealias JSONObject = [String:Any]

final class APIClient {
    private let baseURL = URL(string: "https://api.seatgeek.com/2/")!
    
    func eventsSearch(request:APIRequest) -> Observable<Result<[EventItem]>> {
        return send(apiRequest: request)
            .map({ json -> Result<[EventItem]> in
                guard let eventsJSON = json["events"] as? [JSONObject] else {
                    return Result<[EventItem]>.failure(APIError.cannotParse)
                }
                
                return Result.success(eventsJSON.compactMap { EventItem(object: $0) })
            }).catchError({ error in
                return Single.just(Result<[EventItem]>.failure(error))
            }).asObservable()
    }
    
    private func send(apiRequest: APIRequest) -> Single<JSONObject> {
        let request = apiRequest.request(with: self.baseURL)
        let errorHandler: (Int) -> APIError = { code  in
            if code == 403 {
                return APIError.invalidClientID
            } else if code == -1009 {
                return APIError.noInternet
            } else {
                return APIError.responseError(code: code)
            }
        }
        
        return Single<[String: Any]>.create { single in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    let errorCode = (error as NSError).code
                    single(.error(errorHandler(errorCode)))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                    let result = json as? JSONObject else {
                        single(.error(APIError.cannotParse))
                        return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
