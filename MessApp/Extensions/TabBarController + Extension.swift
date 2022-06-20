//
//  TabBarController + Extension.swift
//  MessApp
//
//  Created by Николай Петров on 05.06.2022.
//

import UIKit

extension UITabBarController {
    
     func setupTabBar() -> UITabBarController? {
        let tabBarVC = UITabBarController()
        let chatVC = UINavigationController(rootViewController: ChatsListViewController())
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
   
        chatVC.title = "Chats"
        favoritesVC.title = "Favorites"
        profileVC.title = "Profile"
        tabBarVC.setViewControllers([chatVC, favoritesVC, profileVC], animated: false)
        
        guard let items = tabBarVC.tabBar.items else { return nil}
        let images = ["house.fill", "star.fill", "arrowshape.turn.up.backward.circle"]
        for name in 0..<items.count {
            items[name].image = UIImage(systemName: images[name])
        }
         
        tabBarVC.tabBar.tintColor = .black
        tabBarVC.modalPresentationStyle = .fullScreen
        return tabBarVC
    }
}
