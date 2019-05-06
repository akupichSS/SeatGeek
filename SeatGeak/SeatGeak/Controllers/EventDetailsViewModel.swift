//
//  EventDetailsViewModel.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import RxSwift

struct EventDetailsViewModel {
    let event: Observable<EventItem>
    
    let onLike = PublishSubject<Bool>()
    let onBack: AnyObserver<Void>
    
    let disposeBag = DisposeBag()
    
    init(event: EventItem, coordinator: SceneCoordinatorType, likeAction: BehaviorSubject<Bool>) {
        self.event = Observable.just(event)
        self.onBack = AnyObserver { _ in
            coordinator.pop(animated: true)
        }
    }
}
