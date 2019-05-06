//
//  NavigationView.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    // TODO: make it more flexible for custom arrays of left and right nav buttons
    @IBOutlet var leftNavigationButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rightNavigationButton: UIButton!
    
    public var title: String {
        set {
            titleLabel.text = newValue
        } get {
            return titleLabel.text ?? ""
        }
    }
}


