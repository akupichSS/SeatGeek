//
//  UIView+Nib.swift
//  SeatGeek
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit

public protocol NameIdentifiable { }

extension NameIdentifiable where Self : UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension NameIdentifiable where Self : UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UIView {
    class func nib() ->  UINib {
        return UINib(nibName: self.identifier, bundle: Bundle(for: self))
    }
}

extension UIViewController : NameIdentifiable {}
extension UIView : NameIdentifiable {}
