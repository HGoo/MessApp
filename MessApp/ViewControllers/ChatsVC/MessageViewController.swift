//
//  MessageViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class MessageViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        //table.isHidden = true
        //table.allowsSelection = false
        table.register(MessageTableViewCell.self, forCellReuseIdentifier: "CellMessage")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var  sendButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    private var users: [[String: String]] = []
    private let currentUser = UserDefaults().getUserLogin()
    private var messages: [[[String: String]]] = []
    private var indexPath: IndexPath!
    
    
    public var receiver: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegate()
        setConstraints()
        registerKeyboardNotification()
        setupMessages()
        //hideKeyboard()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        textView.returnKeyType = .
//       }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupViews() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))

        tableView.addGestureRecognizer(longPressRecognizer)
        
        title = receiver
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        backgroundView.addSubview(messageTextField)
        backgroundView.addSubview(sendButton)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        //passwordTextField.delegate = self
    }
    
    private func hideKeyboard() {
        let tapScreen = UITapGestureRecognizer(target: self,
                                               action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func sendMessageButtonTapped() {
        
        //guard let message = messageTextField.text else { return }
        if messageTextField.text != nil, messageTextField.text?.isEmpty == false {
            createConversation(message: messageTextField.text!)
        }
        
        messageTextField.text = nil
    }
    
    private func createConversation(message: String) {
        DataBaseManager.shared.createConversation(with: receiver, and: currentUser,
                                                  message: message) { success in
            if success {
                
            } else {
                
            }
        }
        
        DataBaseManager.shared.createConversation(with: currentUser, and: receiver,
                                                  message: message) { success in
            if success {
                
            } else {
                
            }
        }
        
    }
    
    private func setupMessages() {
        DataBaseManager.shared.getMessages(for: currentUser, with: receiver) { result in
            switch result {
            case .success(let messages):
                self.messages = messages.reversed()
                self.tableView.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let message = messages[indexPath.row]
                guard let mess = message[1][DBNames.message.rawValue] else { return }
                UIAlertController().alertSaveMessageToDB(message: mess,
                                                         controller: self)
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMessage", for: indexPath) as! MessageTableViewCell
        
        
        let message = messages[indexPath.row]
        cell.configureMessageCell(with: message, receiver)
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
}

//MARK: - Alert

extension MessageViewController {
    public func alertSaveMessageToDB(titel: String = "Add this message to Favorites?",
                                     message: String,
                                     controller: UIViewController,
                                     completion: (Bool) -> ()) {
        
        let alert = UIAlertController(title: titel,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default)
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                      style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        
        controller.present(alert, animated:  true)
    }
}

//MARK: - UITableViewDelegate

extension MessageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        self.indexPath = indexPath
    }
    
    
}

//MARK: - UITextFieldDelegate

extension MessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tableView.endEditing(true)
    }
}

//MARK: - Keyboard Show Hide

extension MessageViewController {
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyBoardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyBoardHeight.height)
    }
    
    @objc private func keyBoardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

//MARK: - Set Constarins

extension MessageViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
            //tableView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            messageTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0),
            messageTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
            messageTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor)
        ]) 
    }
}

