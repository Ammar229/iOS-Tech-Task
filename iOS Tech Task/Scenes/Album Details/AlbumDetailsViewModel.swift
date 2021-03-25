//
//  AlbumViewModel.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/25/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation


class AlbumDetailsViewModel {
    
    // MARK: - init
    init(albumID: Int) {
        self.albumID = albumID
    }
    
    // MARK: - Variables
    private var userManager: UserManager = UserNetworkManager()
    private var isSearch: Bool = false
    var photos: [Photo] = []
    var filteredPhotos: [Photo] = []
    var albumID: Int
    
    var reloadCollectionViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
 
    
    var state: State = .empty {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    
    var numberOfCells: Int {
        isSearch ? filteredPhotos.count: photos.count
    }
    
    var searchState: Bool = false {
        didSet {
           isSearch = searchState
           reloadCollectionViewClosure?()
        }
    }
    
    
    
    
    // MARK: - API Functions
    func getPhotos(for albumID: Int){
        state = .loading
        userManager.getPhotos(for: albumID) { (result) in
            switch result {
            case .success(_, let photos):
                guard let photos = photos else {
                    return
                }
                self.state = .populated
                self.photos = photos
                self.reloadCollectionViewClosure?()
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
}
