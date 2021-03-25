//
//  State.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation

public enum State {
    case loading
    case error(String)
    case empty
    case populated
}
