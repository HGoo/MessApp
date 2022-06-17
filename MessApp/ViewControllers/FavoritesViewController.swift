//
//  FavoritesViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellFavorites")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    public var favoriteMessage: [Favorites] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        print(favoriteMessage)
        setupViews()
        setupDelegate()
        setConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreData.shared.fetchdData()
        CoreData.shared.favoriteMessage = self.favoriteMessage
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //searchController.searchBar.delegate = self
    }
}


extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFavorites", for: indexPath)
        
        let message = favoriteMessage[indexPath.row].message
        
        var content = cell.defaultContentConfiguration()
        content.text = message
        cell.contentConfiguration = content
        return cell
    }
}


extension FavoritesViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
