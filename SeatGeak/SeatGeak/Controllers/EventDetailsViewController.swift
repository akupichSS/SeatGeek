//
//  EventDetailsViewController.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class EventDetailsViewController: UIViewController, BindableType {
    
    @IBOutlet var eventImageView: UIImageView! {
        didSet {
            eventImageView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet var navView: NavigationView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel: EventDetailsViewModel!
    
    func bindViewModel() {
        viewModel.event
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (event) in
                self?.setupData(event: event)
            }).disposed(by: disposeBag)
        
        navView.leftNavigationButton.rx.tap
            .bind(to: viewModel.onBack)
            .disposed(by: disposeBag)
    }
    
    private func setupData (event: EventItem) {
        navView.title = event.title
        navView.rightNavigationButton.isSelected = event.isLiked
        dateLabel.text = event.date?.toString(withFormat: "E, d MMM yyyy h:mm a")
        locationLabel.text = event.location
        
        if !event.imageUrlStr.isEmpty, let imageUrl = URL(string: event.imageUrlStr) {
            eventImageView.kf.setImage(with: imageUrl)
        }
    }
    
    deinit {
        debugPrint ("deinit EventDetailsViewController")
    }
}
