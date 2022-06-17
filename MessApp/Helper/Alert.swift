//
//  File.swift
//  MessApp
//
//  Created by Николай Петров on 17.06.2022.
//

import UIKit

extension UIAlertController {
    
    public func alertUserLoginError(message: String = "Plase enter Username/Login to log in",
                                    controller: UIViewController) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        controller.present(alert, animated:  true)
    }
    
    public func alertSaveMessageToDB(titel: String = "Save this message in Favorites?",
                                     message: String,
                                     controller: UIViewController) {
        
        let alert = UIAlertController(title: titel,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            CoreData.shared.save(message)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                      style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        
        controller.present(alert, animated:  true)
    }

}
