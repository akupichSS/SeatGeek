//
//  TaskItem.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol Convertible {
    init?(object: JSONObject)
}

class EventItem: Object, Convertible {
    @objc dynamic var id: Int = 0
    @objc dynamic var imageUrlStr: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var isLiked: Bool = false
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(object: JSONObject) {
        self.init()
        
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
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
