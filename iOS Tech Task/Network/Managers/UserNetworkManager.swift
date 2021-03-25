//
//  UserNetworkManager.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation
import Moya

typealias UserDataBlock = (DataResult<User>) -> Void
typealias AlbumDataBlock = (DataResult<Album>) -> Void
typealias PhotoDataBlock = (DataResult<Photo>) -> Void


protocol UserManager {
    func getInfo(for userID: Int, completion: @escaping UserDataBlock)
    func getAlbums(for userID: Int, completion: @escaping AlbumDataBlock)
    func getPhotos(for albumID: Int, completion: @escaping PhotoDataBlock)
}


class UserNetworkManager: UserManager, HandleNetworkManager {

    private var moyaProvider: MoyaProvider<UserServices>
    init(_ moyaProvider: MoyaProvider<UserServices> = MoyaProvider<UserServices>()) {
        self.moyaProvider = moyaProvider
    }
    
    
    
    func getInfo(for userID: Int, completion: @escaping UserDataBlock) {
        moyaProvider.request(.getInfo(userID: userID)) { [weak self] (result) in
            self?.handleNetworkResponse(result: result, completion: completion)
        }
    }
    
    
    func getAlbums(for userID: Int, completion: @escaping AlbumDataBlock) {
        moyaProvider.request(.getAlbums(userID: userID)) { [weak self] (result) in
            self?.handleNetworkResponse(result: result, completion: completion, isList: true)
        }
    }
    
    func getPhotos(for albumID: Int, completion: @escaping PhotoDataBlock) {
        moyaProvider.request(.getPhotos(albumID: albumID)) { [weak self] (result) in
            self?.handleNetworkResponse(result: result, completion: completion, isList: true)
        }
    }
}




