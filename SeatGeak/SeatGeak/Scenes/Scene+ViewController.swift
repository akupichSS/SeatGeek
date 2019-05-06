//
//  Scene+ViewController.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .events(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier:
                "EventsNav") as! UINavigationController
            var vc = nc.viewControllers.first as! EventsViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .eventDetails(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier:
                "EventDetails") as! EventDetailsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        } }
}
