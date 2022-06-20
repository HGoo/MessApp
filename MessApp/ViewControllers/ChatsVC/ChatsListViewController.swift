//
//  ChatsListViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class ChatsListViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellChatsList")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var users: [String] = []
    private let currentUser = UserDefaults().getUserLogin()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegate()
        setConstraints()
        setUsersList()
    }
        
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUsersList() {
        DataBaseManager.shared.getAllUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userCollection):
                self.sorted(userCollection)
                self.tableView.reloadData()
            case .failure(let error):
                print("Faild to get users: \(error)")
            }
        }
    }
    
    private func sorted(_ userCollection: [[String : String]]) {
        var usersSorted: [String] = []
        for user in userCollection {
            if user[DBNames.userLogin.rawValue] != currentUser {
                usersSorted.append(contentsOf: user.values)
            }
        }
        users = usersSorted
    }
}

//MARK: - UITableViewDataSource

extension ChatsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellChatsList", for: indexPath)
        let user = users[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = user
        cell.contentConfiguration = content
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ChatsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let messageVC = MessageViewController()
        messageVC.receiver = user
        messageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messageVC, animated: true)
    }
}

extension ChatsListViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
