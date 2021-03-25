//
//  ProfileViewModel.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Variables
    private var userManager: UserManager = UserNetworkManager()
    private var albums: [Album] = []
    var reloadTableViewClosure: (()->())?
    var updateUserInfoClosure: ((User)->())?
    var updateLoadingStatus: (()->())?
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var numberOfCells: Int {
        albums.count
    }
    
    
    
    
    // MARK: - API Functions
    func getUserInfo(for id: Int = 1) {
        state = .loading
        userManager.getInfo(for: id) { (result) in
            switch result {
            case .success(let user, _):
                guard let user = user else {
                    return
                }
                self.state = .populated
                self.updateUserInfoClosure?(user)
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    
    func getUserAlbums(for userID: Int = 1) {
        state = .loading
        userManager.getAlbums(for: userID) { (result) in
            switch result {
            case .success(_, let albums):
                guard let albums = albums else {
                    return
                }
                self.state = .populated
                self.albums = albums
                self.reloadTableViewClosure?()
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Config Data Functions
    func getAlbum(at indexPath: IndexPath) -> Album {
        albums[indexPath.row]
    }
    
}
