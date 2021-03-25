//
//  Loadable.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol Loadable {
    // Loading indicator
    func startLoading()
    func stopLoading()
}

extension Loadable where Self: UIViewController {
    // Loading indicator
    func startLoading() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func stopLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
