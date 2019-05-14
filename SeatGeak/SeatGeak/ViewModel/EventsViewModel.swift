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
    
    private let sceneCoordinator: SceneCoordinatorType
    private let apiClient: APIClient
    private let storage: EventsStorageType
    private let model: EventsList
    private let disposeBag = DisposeBag()
    
    let searchText = BehaviorSubject(value: "")
    
    let sectionsWithEvents = BehaviorSubject<[EventsSection]>(value: [])
    let onShowError = PublishSubject<Error>()
    
    init(apiClient: APIClient, storage: EventsStorageType, coordinator: SceneCoordinatorType) {
        self.apiClient = apiClient
        self.storage = storage
        self.model = EventsList()
        self.sceneCoordinator = coordinator
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        self.searchText
            .filter {!$0.isEmpty}
            .subscribe(onNext: {
                self.model.fetchEvents(for: $0, using: self.apiClient)
            }).disposed(by: disposeBag)
        
        // TODO: bind also cancel action here to cancel request
    }
    
    func bindOutput() {
        model
            .events
            .map { events in
                events.map { event in
                    event.setupLikeStatus(self.storage)
                }}
            .map{ [EventsSection(model: "Section Events", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(sectionsWithEvents)
            .disposed(by: disposeBag)
        
        model
            .onError
            .bind(to: onShowError)
            .disposed(by: disposeBag)
    }
    
    @discardableResult
    func showDetails(of event:EventItem) -> Completable {
        let eventDetailsViewModel = EventDetailsViewModel(
            event: event,
            coordinator: sceneCoordinator,
            storage: storage
        )
        return self.sceneCoordinator.transition(to:
            Scene.eventDetails(eventDetailsViewModel), type: .push)
    }
}

