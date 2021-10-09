//
//  FavoritesListVC.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 31.8.21.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        getFavorites()
    }
    
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        view.backgroundColor = .systemBackground
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case.success(let favorites):
                self.updateTableUI(with: favorites)
                
            case.failure(let error):
                self.presentDBAlertVCOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func updateTableUI(with favorites: [User]) {
        if favorites.isEmpty {
            showEmptyStateView(with: "You don't have any favorite users... yet!\n Add one by tapping the \"+\" in the detailed user info view.", in: self.view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
                self.view.subviews.forEach { subView in
                    if subView is DBEmptyStateView {
                        subView.removeFromSuperview()
                    }
                }
            }
        }
    }
}


extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = UserInfoVC()
        let navController = UINavigationController(rootViewController: destVC)
        destVC.userID = favorite.id
        destVC.updateDelegate = self
        
        navigationController?.present(navController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [ weak self ] error in
            guard let self = self else { return }
            
            guard let error = error else {
                DispatchQueue.main.async {
                    self.favorites.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    if self.favorites.isEmpty {
                        self.showEmptyStateView(with: "You don't have any favorite users... yet!\n Add one by tapping the \"+\" in the detailed user info view.", in: self.view)
                    }
                }
                return
            }
            self.presentDBAlertVCOnMainThread(title: "Unable to delete", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension FavoritesListVC: UserInfoVCDelegate {
    
    func didTapDoneButton(_ viewController: UserInfoVC) {
        viewController.dismiss(animated: true)
        getFavorites()
    }
}





