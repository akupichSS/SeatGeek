//
//  EventsStorageType.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum EventsStorageError: Error {
    case creationFailed(EventItem)
    case deletionFailed(EventItem)
    case searchingFailed(EventItem)
}

protocol EventsStorageType {
    @discardableResult
    func create(event: EventItem) -> Observable<Void>
    @discardableResult
    func delete(event: EventItem) -> Observable<Void>
    @discardableResult
    func find(event:EventItem) -> EventItem?
    func logCountOfStoredEvents ()
}
