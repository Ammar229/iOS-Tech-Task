//
//  DefaultResponse.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation


struct DefaultResponse: Codable {
    let code: Int?
    let state: Bool?
    let message: String?
}
