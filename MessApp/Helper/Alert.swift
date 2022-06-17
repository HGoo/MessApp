//
//  File.swift
//  MessApp
//
//  Created by Николай Петров on 17.06.2022.
//

import UIKit

class ShowAlert {
    static let shred = ShowAlert()
    
    public func alertUserLoginError(message: String = "Plase enter Username/Login to log in",
                                    controller: UIViewController) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        controller.present(alert, animated:  true)
    }

}
