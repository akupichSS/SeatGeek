//
//  EventsViewModel.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias EventsSection = SectionModel<String, EventItem>

struct EventsViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let apiClient: APIClient
    let storage: EventsStorageType
    let disposeBag = DisposeBag()
    
    let searchText = BehaviorSubject(value: "")
    
    var events = BehaviorSubject<[EventsSection]>(value: [])
    
    init(apiClient: APIClient, storage: EventsStorageType, coordinator: SceneCoordinatorType) {
        self.apiClient = apiClient
        self.storage = storage
        self.sceneCoordinator = coordinator
        
        bindOutput()
    }
    
    func bindOutput() {
        self.searchText
            .filter {!$0.isEmpty}
            .map {SearchRequest(query: $0)}
            .flatMap { request in
                return self.apiClient.eventsSearch(request: request)
            }
            .map { result -> [EventItem] in
                switch result {
                case .success(let events):
                    return events.map (self.configureLikeStatus)
                case .failure(let error):
                    // TODO: Display UI error
                    print ("APIError = \(error)")
                    return []
                }
            }
            .map{ [EventsSection(model: "Section Events", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(events)
            .disposed(by: disposeBag)
    }
    
    @discardableResult
    func showDetails(of event:EventItem) -> Completable {
        let eventDetailsViewModel = EventDetailsViewModel(
            event: event,
            coordinator: self.sceneCoordinator,
            likeAction: self.onLiked(event)
        )
        return self.sceneCoordinator.transition(to:
            Scene.eventDetails(eventDetailsViewModel), type: .push)
    }
    
    func onLiked(_ event:EventItem) -> PublishSubject<Bool> {
        let likeSubject = PublishSubject<Bool>()
        
        likeSubject.subscribe(onNext: { (isFavourite) in
            if isFavourite {
                self.storage.create(event: event)
            } else {
                self.storage.delete(event: event)
            }
            #if DEBUG
                self.storage.logCountOfStoredEvents()
            #endif
            
        }).disposed(by: disposeBag)
        
        
        return likeSubject
    }
    
    private func configureLikeStatus(for event:EventItem) ->EventItem {
        event.isLiked = storage.find(event: event) != nil
        return event
    }
}

