//
//  TabBarViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let chatVC = ChatsListViewController()
        let favoritesVC = FavoritesViewController()
        let profileVC = ProfileViewController()
        
        chatVC.title = "Chats"
        favoritesVC.title = "Favorites"
        profileVC.title = "Profile"
        
        setViewControllers([chatVC, favoritesVC, profileVC], animated: false )
    
        
        guard let item = tabBar.items else { return }
        
        let images = ["house", "house", "house"]
        
        for x in 0..<images.count {
            item[x].image = UIImage(systemName: images[x])
        }
        
        tabBar.tintColor = .black
    }
}
