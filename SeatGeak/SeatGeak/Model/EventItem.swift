//
//  TaskItem.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation

struct EventItem {
    var id: Int = 0
    var imageUrlStr: String = ""
    var title: String = ""
    var location: String = ""
    var date: Date?
    var isLiked: Bool = false
    
    init?(object: JSONObject) {
        guard let id = object["id"] as? Int else {
                return nil
        }
        self.id = id
        self.imageUrlStr = (object["performers"] as? [JSONObject])?.first?["image"] as? String ?? ""
        self.title = object["title"] as? String ?? ""
        self.location = (object["venue"] as? JSONObject)?["display_location"] as? String ?? ""
        if let dateStr = object["datetime_local"] as? String {
            self.date = dateStr.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss)")
        }
    }
}
