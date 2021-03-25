//
//  UIView+ReusableIdentifier.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import UIKit

/// Default identifier added to UIViews
protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

// MARK: UIView+ReusableIdentifier
extension UIView: ReusableIdentifier {}
