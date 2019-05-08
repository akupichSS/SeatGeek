//
//  BindableType.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit
import RxSwift

protocol BindableViewController {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension BindableViewController where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
