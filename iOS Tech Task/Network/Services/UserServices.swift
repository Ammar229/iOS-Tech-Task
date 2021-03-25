//
//  UserServices.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation
import Moya

enum UserServices {
    case getInfo(userID: Int)
    case getAlbums(userID: Int)
    case getPhotos(albumID: Int)
}


extension UserServices: TargetType {
    var baseURL: URL {
        return URL (string: "https://jsonplaceholder.typicode.com/")!
    }
    
    var path: String {
        switch self {
        case .getInfo(userID: let userID):
            return "users/\(userID)"
        case .getAlbums(userID: let userID):
            return "users/\(userID)/albums"
        case .getPhotos(albumID: let albumID):
            return "albums/\(albumID)/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInfo, .getAlbums, .getPhotos:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getInfo, .getAlbums, .getPhotos:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var httpHeaders: [String: String] = [:]
        httpHeaders["Content-Type"] = "application/json"
        return httpHeaders
    }
    
    
}
