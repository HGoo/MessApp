//
//  File.swift
//  MessApp
//
//  Created by Николай Петров on 17.06.2022.
//

import UIKit

extension UIAlertController {
    public func alertError(message: String = "Plase enter Username/Login to log in",
                           title: String = "Wrong Username",
                           controller: UIViewController) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        controller.present(alert, animated:  true)
    }
}
