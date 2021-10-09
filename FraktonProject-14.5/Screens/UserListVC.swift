//
//  UserListVC.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 2.9.21.
//

import UIKit

class UserListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var users: [User] = []
    var filteredUsers: [User] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    var perPage: Int = 6
    var hasMoreUsers = true
    var isSearching = false
    var isLoadingMoreUsers = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getUsers(perPage: perPage)
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseID)
        collectionView.delegate = self
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search users"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    func getUsers(perPage: Int) {
        showLoadingView()
        isLoadingMoreUsers = true
        
        NetworkManager.shared.getUsers(perPage: perPage) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let users):
                if users.count >= 12 { self.hasMoreUsers = false }
                self.users = users
                self.updateData(on: users)
            case .failure(let error):
                self.presentDBAlertVCOnMainThread(title: "Something went wrong 🧐", message: error.rawValue, buttonTitle: "Ok")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.isLoadingMoreUsers = false
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseID, for: indexPath) as! UserCell
            cell.set(user: user)
            return cell
        })
    }
    
    
    func updateData(on users: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension UserListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreUsers, !isLoadingMoreUsers else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            perPage += 6
            getUsers(perPage: perPage)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeUsersArray = isSearching ? filteredUsers : users
        let user = activeUsersArray[indexPath.item]
        
        let userInfoVC = UserInfoVC()
        let navController = UINavigationController(rootViewController: userInfoVC)
        //userInfoVC.userInfo = [user.self]
        userInfoVC.userID = user.id
        present(navController, animated: true)
    }
}

extension UserListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            isSearching = false
            filteredUsers.removeAll()
            updateData(on: users)
            return
        }
        isSearching = true
        filteredUsers = users.filter { $0.fullName!.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredUsers)
    }
}
