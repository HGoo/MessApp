//
//  ConversationsViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit
import FirebaseDatabase

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        print(UserDefaults().isLoggedIn())
        if UserDefaults().isLoggedIn() {
//            guard let tabbar = UITabBarController().setupTabBar() else { return }
//            UserDefaults().setLoggedIn(value: true)
//            self.present(tabbar, animated: true)
        } else {
            let authVC = LoginViewController()
            let nav = UINavigationController(rootViewController: authVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }


}
