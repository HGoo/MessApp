//
//  FavoritesViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellFavorites")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var favoriteMessage: [Favorites] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegate()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.shared.fetchdData { [weak self] favotites in
            guard let self = self else { return }
            self.favoriteMessage = favotites
            self.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        title = "Favorites"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteMessage.count
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

//MARK: - UITableViewDelegate

extension FavoritesViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: -  Add swipe and tap action

extension FavoritesViewController {
    private func delete(rowIndexPathAt  indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.alertDeleteMessage(indexPath)
        }
        return action
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
}

// MARK: - Alert

extension FavoritesViewController {
    private func alertDeleteMessage(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure you want to remove message?",
                                      message: "",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .destructive, handler: { [weak self ]_ in
            guard let self = self else { return }
            let message = self.favoriteMessage[indexPath.row]
            CoreData.shared.deleteMessage(message) { [weak self] in
                guard let self = self else { return }
                self.favoriteMessage.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated:  true)
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
