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
        //table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellChatsList")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let lable = UILabel()
        lable.text = "NO Conversations!"
        lable.isHidden = true
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private var users = [String]()
    private var companionName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5232761502, green: 1, blue: 0.9808334708, alpha: 1)
            
        setupViews()
        setupDelegate()
        setConstraints()
        fetchonversations()
        setUsersList()

    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        tableView.reloadData()
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableView.frame = view.bounds
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //searchController.searchBar.delegate = self
    }
    private func fetchonversations() {
        tableView.isHidden = false
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
        var usersSorted = [String]()
        for user in userCollection {
            if user[DBNames.userLogin.rawValue] != UserDefaults().getUserLogin() {
                usersSorted.append(contentsOf: user.values)
            }
        }
        self.users = usersSorted
    }
    
    deinit {
        print("Deinit CtatListVC")
    }
}

//MARK: - UITableViewDataSource

extension ChatsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellChatsList", for: indexPath) //as! AlbumsTableViewCell
        
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
        let chatVC = MessageViewController()
        chatVC.receiver = user
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
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
