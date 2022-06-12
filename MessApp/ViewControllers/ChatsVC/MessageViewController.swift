//
//  MessageViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class MessageViewController: UIViewController {
    
    private var testMess = ["1","2","3","4","5","te32st","te32st","tes32t","t23est","tes23t","te23st","tes23t","tes23t","te2st","te32st","test","tes314ut","teyst","5","6","7","8","9"]
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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellChatsList")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var  sendButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegate()
        setConstraints()
        registerKeyboardNotification()
        //hideKeyboard()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        textView.returnKeyType = .
//       }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupViews() {
        //title = "SignIn"
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
    
    @objc func sendButtonTapped() {
        messageTextField.text = nil
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

//MARK: - UITableViewDataSource

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testMess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellChatsList", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = testMess[indexPath.row]
        cell.contentConfiguration = content
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension MessageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            tableView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
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

