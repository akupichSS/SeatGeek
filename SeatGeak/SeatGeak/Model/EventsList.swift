//
//  EventsList.swift
//  SeatGeak
//
//  Created by Andriy Kupich on 5/7/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import RxSwift

struct EventsList {
    let events = BehaviorSubject<[EventItem]>(value: [])
    let onError = PublishSubject<Error>()
    let disposeBag = DisposeBag()
    
    func fetchEvents(for query:String, using apiClient:APIClient) {
        Observable.just(SearchRequest(query: query))
            .concat(Observable.never()) // keep it alive until dispose bag become nil
            .flatMap { request in
                return apiClient.eventsSearch(request: request)
            }.map { result -> [EventItem] in
                switch result {
                case .success(let events):
                    return events
                case .failure(let error):
                    self.onError.onNext(error)
                    return []
                }}
            .bind(to: events)
            .disposed(by: disposeBag)
    }
}
