//
//  EventTableViewCell.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class EventItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.layer.cornerRadius = 10.0
            eventImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var isLikedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        eventImageView.image = nil
        super.prepareForReuse()
    }
    
    func configure(with item: EventItem) {
        if !item.imageUrlStr.isEmpty, let imageUrl = URL(string: item.imageUrlStr) {
            eventImageView.kf.setImage(with: imageUrl)
        }
        
        titleLabel.text = item.title
        locationLabel.text = item.location
        dateLabel.text = item.date?.toString(withFormat: "E, d MMM yyyy h:mm a")
    }    
}
