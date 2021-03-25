//
//  AlbumDetailsVC.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import UIKit
import Toast_Swift
import SDWebImage

class AlbumDetailsVC: UIViewController, Loadable {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    

    // MARK: - Variables
    private var viewModel: AlbumDetailsViewModel!
    private var userManager: UserManager = UserNetworkManager()
    
    init(viewModel: AlbumDetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configerViews()
        bindVM()
        viewModel.getPhotos(for: viewModel.albumID)
    }
    
    
    // MARK: - UI Function
    private func configerViews() {
        self.navigationItem.title = "Album Details"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PhotoCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.identifier)
        searchBar.delegate = self
    }
    
    
    // MARK: - Bind Function
    func bindVM() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }
            switch self.viewModel.state {
            case .error(let msg):
                self.stopLoading()
                self.view.makeToast(msg, duration: 3.0, position: .top)
            case .loading:
                self.startLoading()
            case .populated:
                self.stopLoading()
            case .empty:
                break
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}



extension AlbumDetailsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            debugPrint("Couldn't dequeue a cell of type \(PhotoCell.identifier)")
            return UICollectionViewCell()
        }
        if viewModel.searchState {
            cell.imageView.sd_setImage(with: URL(string: viewModel.filteredPhotos[indexPath.row].url ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-600x600"))
        } else {
            cell.imageView.sd_setImage(with: URL(string: viewModel.photos[indexPath.row].url ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-600x600"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.width/3)
    }
    
}





extension AlbumDetailsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            viewModel.searchState = false
        } else {
            viewModel.searchState = true
            viewModel.filteredPhotos = viewModel.photos.filter({($0.title?.contains(searchBar.text!.lowercased()) ?? false)})
        }
    }
}
