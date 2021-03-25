//
//  ProfileVC.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import UIKit
import Toast_Swift

class ProfileVC: UIViewController, Loadable {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var viewModel: ProfileViewModel = ProfileViewModel()

    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindVM()
        viewModel.getUserInfo()
        viewModel.getUserAlbums()
    }
    
    // MARK: - Bind Function
    func bindVM() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }
            switch self.viewModel.state {
            case .loading:
                self.startLoading()
                debugPrint("here")
            case .populated:
                self.stopLoading()
                debugPrint("leave")
            case .error(let msg):
                self.stopLoading()
                self.view.makeToast(msg, duration: 3.0, position: .top)
            case .empty:
                break
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.updateUserInfoClosure = { [weak self] user in
            self?.configureData(for: user)
        }
    }
    
    
    // MARK: - UI Functions
    private func configureViews() {
        self.navigationItem.title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AlbumCell.identifier, bundle: nil), forCellReuseIdentifier: AlbumCell.identifier)
    }
    
    
    private func configureData(for user: User) {
        nameLabel.text = user.name
        adressLabel.text = "\(user.address?.street ?? ""), \(user.address?.suite ?? ""), \(user.address?.city ?? ""), \(user.address?.zipcode ?? "")"
    }
}


extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
            debugPrint("Couldn't dequeue a cell of type \(AlbumCell.identifier)")
            return UITableViewCell()
        }
        cell.albumName.text = viewModel.getAlbum(at: indexPath).title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumID = viewModel.getAlbum(at: indexPath).id else {
            return
        }
        let albumDetailsVC = AlbumDetailsVC(viewModel: AlbumDetailsViewModel(albumID: albumID))
        self.navigationController?.pushViewController(albumDetailsVC, animated: true)
    }
}
