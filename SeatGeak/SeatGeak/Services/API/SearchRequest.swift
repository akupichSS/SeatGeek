//
//  SearchRequest.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation

struct SearchRequest: APIRequest {
    var method = RequestType.GET
    var path = "events"
    var parameters = [String: String]()
    
    init(query: String) {
        parameters["q"] = query
    }
}
