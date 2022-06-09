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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5232761502, green: 1, blue: 0.9808334708, alpha: 1)
        
        setupViews()
        setupDelegate()
        setConstraints()
        fetchonversations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableView.frame = view.bounds
    }
    
    private func setupViews() {
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


}

//MARK: - UITableViewDataSource

extension ChatsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellChatsList", for: indexPath) //as! AlbumsTableViewCell
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "GHFJHFssfdfs"
        
        cell.contentConfiguration = content
//        let album = albums[indexPath.row]
//        cell.configureAlbumCell(album: album)
        //cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ChatsListViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController = DetailAlbumViewController()
//
//        let album = albums[indexPath.row]
//        detailViewController.album = album
//        detailViewController.title = album.artistName
//        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chatVC = ChatViewController()
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
