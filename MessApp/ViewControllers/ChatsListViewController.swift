//
//  ChatsListViewController.swift
//  MessApp
//
//  Created by Николай Петров on 01.06.2022.
//

import UIKit

class ChatsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5232761502, green: 1, blue: 0.9808334708, alpha: 1)
        //title = "Chats"
        
        // Do any additional setup after loading the view.
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(aaa)
        )
    }
    
    @objc private func aaa() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
