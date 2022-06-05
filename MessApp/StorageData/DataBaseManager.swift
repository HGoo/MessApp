//
//  DataBaseManager.swift
//  MessApp
//
//  Created by Николай Петров on 03.06.2022.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
    
}

extension DataBaseManager {
    
    public func validateNewUser(with login: String, completion: @escaping ((Bool) -> ())) {
        database.child(login).child("User_login").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil
            else {
                print(snapshot.value!)
                completion(false)
                return
            }
            print(snapshot.value!)
            completion(true)
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.userLogin).setValue(["User_login": user.userLogin])
    }
    
}

struct ChatAppUser {
    let userLogin: String
}

 
