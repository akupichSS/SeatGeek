//
//  EventsStorage.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

struct EventsStorage: EventsStorageType {
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let error {
            print("Failed \(operation) realm with error: \(error)")
            return nil
        }
    }
    
    @discardableResult
    func create(event: EventItem) -> Observable<Void> {
        let result = withRealm("creating") { realm -> Observable<Void> in
            try realm.write {
                realm.create(EventItem.self, value: event, update: true)
            }
            return .empty()
        }
        return result ?? .error(EventsStorageError.creationFailed(event))
    }
    
    @discardableResult
    func delete(event: EventItem) -> Observable<Void> {
        let result = withRealm("deleting") { realm-> Observable<Void> in
            try realm.write {
                if let storedEvent = realm.object(ofType: EventItem.self, forPrimaryKey: event.id) {
                    realm.delete(storedEvent)
                }
            }
            return .empty()
        }
        return result ?? .error(EventsStorageError.deletionFailed(event))
    }
    
    @discardableResult
    func find(event:EventItem) -> EventItem? {
        return withRealm("searching") { realm in
            return realm.object(ofType: EventItem.self, forPrimaryKey: event.id)
            } ?? nil
    }
    
    func logCountOfStoredEvents () {
        _ = withRealm("count") { realm in
            let count = realm.objects(EventItem.self).count
            print ("[DEBUG] Liked events count = \(count)")
        }
    }
}
