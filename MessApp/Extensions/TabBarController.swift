////
////  TabBarController.swift
////  MessApp
////
////  Created by Николай Петров on 05.06.2022.
////
//
//import Foundation
//import UIKit
//
//extension UITabBarController {
//    
//     func setupTabBar() -> UITabBarController? {
//        let tabBarVC = UITabBarController()
//        
//        let chatVC = UINavigationController(rootViewController: ChatsListViewController())
//        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
//        let profileVC = UINavigationController(rootViewController: ProfileViewController())
//        
//        chatVC.title = "Chats"
//        favoritesVC.title = "Favorites"
//        profileVC.title = "Profile"
//        
//        tabBarVC.setViewControllers([chatVC, favoritesVC, profileVC], animated: false)
//        
//        guard let items = tabBarVC.tabBar.items else { return nil}
//        
//        let images = ["house", "house", "house"]
//        
//        for x in 0..<items.count {
//            items[x].image = UIImage(systemName: images[x])
//        }
//        tabBarVC.tabBar.tintColor = .black
//        
//        tabBarVC.modalPresentationStyle = .fullScreen
//        
//        return tabBarVC
//    }
//}
