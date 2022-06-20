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
        textField.placeholder = "Type your message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MessageTableViewCell.self, forCellReuseIdentifier: "CellMessage")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var  sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let currentUser = UserDefaults().getUserLogin()
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    private var messages: [[[String: String]]] = []
    private var favoriteMessage: [Favorites] = []
    public var receiver: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegate()
        setConstraints()
        registerKeyboardNotification()
        setupMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageTextField.returnKeyType = .continue
    }
    
    private func setupViews() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        title = receiver
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
    }
    
    private func createConversation(message: String) {
        // Append/create messege/conversation in current user node
        DataBaseManager.shared.createConversation(with: receiver, and: currentUser,
                                                  message: message) { success in
            if !success {
                UIAlertController().alertError(message: "Message not sent",
                                               title: "",
                                               controller: self)
            }
        }
        // Append/create messege/conversation in receiver user node
        DataBaseManager.shared.createConversation(with: currentUser, and: receiver,
                                                  message: message) { success in
            if !success {
                UIAlertController().alertError(message: "Message not sent",
                                               title: "",
                                               controller: self)
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
    
    @objc func sendMessageButtonTapped() {
        if messageTextField.text != nil, messageTextField.text?.isEmpty == false {
            createConversation(message: messageTextField.text!)
        }
        messageTextField.text = nil
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let message = DBMessageField.text.rawValue
                let id = DBMessageField.id.rawValue
                guard let text = messages[indexPath.row][message][DBNames.message.rawValue] else { return }
                guard let id = messages[indexPath.row][id][DBNames.id.rawValue] else { return }
                alertSaveMessageToDB(Message(message: text, messageId: id))
            }
        }
    }
    
    deinit {
        removeKeyboardNotification()
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
        cell.configureMessageCell(with: message)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Alert

extension MessageViewController {
    private func alertSaveMessageToDB(_ message: Message) {
        CoreData.shared.fetchdData { [weak self] favorites in
            guard let self = self else { return }
            self.favoriteMessage = favorites
        }
        
        let (isDublicateMessage, index) = checkMessage(with: message.messageId)
        let title = isDublicateMessage ? "Delete" : "Save"
        
        let alert = UIAlertController(title: "\(title) this message in Favorites?",
                                      message: message.message,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: title,
                                       style: .default) { [weak self] _ in
            guard let self = self else { return }
            let core = CoreData.shared
            isDublicateMessage ? core.deleteMessage(self.favoriteMessage[index]) : core.save(message)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated:  true)
    }
    
    private func checkMessage(with id: String) -> (Bool, Int) {
        var count = -1
        for message in favoriteMessage {
            count += 1
            if message.id == id {
                return (true, count)
            }
        }
        return (false, count)
    }
    
}

//MARK: - UITextFieldDelegate

extension MessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
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
