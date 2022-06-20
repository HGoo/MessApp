//
//  ProfileViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit


class ProfileViewController: UIViewController {
    private lazy var  logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget( self,
                         action: #selector(logOutButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let userNameLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Name"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        userNameLabel.text = UserDefaults().getUserLogin()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
    }
    
    @objc private func logOutButtonTapped() {
        UserDefaults().setLoggedIn(value: false)
        UserDefaults().setUserLogin(value: UserDefaultsKeys.defaultName.rawValue)
        DataBaseManager.shared.removeAllObservers()
        CoreData.shared.deleteAllMessage {
            let authVC = UINavigationController(rootViewController: LoginViewController())
            authVC.modalPresentationStyle = .fullScreen
            present(authVC, animated: true)
            print(UserDefaults().isLoggedIn())
        }
    }
}

//MARK: - Set Constarins

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)

        ])
    }
}
