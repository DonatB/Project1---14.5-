//
//  DBTabBarController.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 22.9.21.
//

import UIKit

class DBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemYellow
        viewControllers = [createMainNavigationController(), createFavoritesNavigationController()]

    }
    
    
    func createMainNavigationController() -> UINavigationController {
        let mainVC = MainVC()
        mainVC.title = "Main Page"
        mainVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        return UINavigationController(rootViewController: mainVC)
    }
    
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favoritesNC = FavoritesListVC()
        favoritesNC.title = "Favorites"
        favoritesNC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesNC)
    }
}
