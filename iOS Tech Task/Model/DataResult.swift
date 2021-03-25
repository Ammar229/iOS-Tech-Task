//
//  DataResult.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation


enum DataResult<T> {
    case success(T?, [T]?)
    case failure(Error)
}


enum APIError: LocalizedError {
    case parsing
    case mapping
    case severError(String)
    var  errorDescription: String? {
        switch self {
        case .parsing:
            return "Error! failed to decode json object"
        case .mapping:
            return "Error! failed to mapping Json object"
        case .severError(let message):
            return message
        }
    }
}




enum NetworkResponse: String {
    case authenticationError = "Wrong credentials invalid username or password"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
}
