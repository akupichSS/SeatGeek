//
//  EventsViewModel.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import RxSwift

struct EventsViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let apiClient: APIClient
    
    init(apiClient: APIClient, coordinator: SceneCoordinatorType) {
        self.apiClient = apiClient
        self.sceneCoordinator = coordinator
    }
}
