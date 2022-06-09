//
//  LoginViewController.swift
//  MessApp
//
//  Created by Николай Петров on 31.05.2022.
//

import UIKit

class LoginViewController: UIViewController {
  
    private let loginTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Login"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("SignUp", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget( self,
                         action: #selector(signUpButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginLabel: UILabel = {
        let lable = UILabel()
        lable.text = "LogIn"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegate()
        setConstraints()
    }
    
    
    
    private func setupViews() {
        view.backgroundColor = .white
        
        textFieldsStackView = UIStackView(arrangedSubviews: [loginTextField],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)
        
        buttonsStackView = UIStackView(arrangedSubviews: [signUpButton],
                                       axis: .horizontal,
                                       spacing: 10,
                                       distribution: .fillProportionally)
        
        view.addSubview(loginLabel)
        view.addSubview(textFieldsStackView)
        view.addSubview(buttonsStackView)
    }
    
    private func setupDelegate() {
        loginTextField.delegate = self
    }
    
    
    
    private func alertUserLoginError(message: String = "Plase enter Username/Login to log in") {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        present(alert, animated:  true)
    }
    
    @objc private func signUpButtonTapped(){
        guard let login = loginTextField.text,
                !login.isEmpty,
                login.count >= 1 else {
            alertUserLoginError()
            return
        }
        
        // Firebase login
        DataBaseManager.shared.validateNewUser(with: login) { [weak self] exsists in
            guard let self = self else { return }
            print(exsists,"exsists")
//            guard !exsists else {
//                // user already exists
//                self.alertUserLoginError(message: "user already exists")
//                return
//            }
            
            DataBaseManager.shared.insertUser(with: ChatAppUser(userLogin: login))
            
            self.loginTextField.resignFirstResponder()
            self.loginTextField.text = nil
            guard let tabbar = UITabBarController().setupTabBar() else { return }
            UserDefaults().setLoggedIn(value: true)
            UserDefaults().setUserLogin(value: login)
            print(UserDefaults().isLoggedIn(),"Login")
            self.present(tabbar, animated: true)
        }
        
        
    }
    
    
    
    deinit {
        print("Deinit LoginVC")
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpButtonTapped()
        return true
    }
    
}

//MARK: - Set Constarins

extension LoginViewController {
    
    private func setConstraints() {
                
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -20),
        ])

        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 20),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
            //textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerXAnchor),


        ])

//        NSLayoutConstraint.activate([
//            signUpButton.heightAnchor.constraint(equalToConstant: 40),
//        ])

        
    }
}
