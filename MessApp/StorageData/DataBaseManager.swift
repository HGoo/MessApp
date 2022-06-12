//
//  DataBaseManager.swift
//  MessApp
//
//  Created by Николай Петров on 03.06.2022.
//

import Foundation
import FirebaseDatabase

enum Names: String {
    case users = "Users"
    case name = "Name"
    case userLogin = "User_login"
}

enum DataBaseError: Error {
    case faiedFetch
}

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
}

extension DataBaseManager {
    
    public func validateNewUser(with login: String, completion: @escaping ((Bool) -> ())) {
        database.child(login).child(Names.userLogin.rawValue).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.value ?? "akljhdfjsdlfhgsdjh")
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
    
    //    /// Insert new user to database
    //    public func insertUser(with user: ChatAppUser) {
    //        //database.child(user.userLogin).setValue(["User_login": user.userLogin])
    //        database.child("UsersDB").child(user.userLogin).setValue(["User_login": user.userLogin])
    //    }
    //
    //    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> ()) {
    //        database.child(user.userLogin).setValue(["User_login": user.userLogin]) { error, _ in
    //            guard error == nil else {
    //                print("failed to write to database")
    //                completion(false)
    //                return
    //            }
    //            completion(true)
    //        }
    //    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.userLogin).setValue([Names.userLogin.rawValue: user.userLogin])
        
        database.child(Names.users.rawValue).observeSingleEvent(of: .value) { snaphot in
            if var userCollection = snaphot.value as? [[String: String]] {
                //append to userdictionary
                let newElement = [
                    [Names.name.rawValue: user.userLogin]
                ]

                userCollection.append([Names.name.rawValue: user.userLogin])
                print("OLD")
                self.database.child(Names.users.rawValue).setValue(userCollection) { error, _ in
                    guard error == nil else { return }
                }
            } else {
                //create that dictionary
                let newCollection: [[String: String]] = [
                    [Names.name.rawValue: user.userLogin]
                ]
                print("New")
                self.database.child("Users").setValue(newCollection) { error, _ in
                    guard error == nil else { return }
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> ()) {
        database.child(Names.users.rawValue).observe(.value) { snapshot in
            //print(snapshot.value)
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DataBaseError.faiedFetch))
                return
            }
            completion(.success(value))
        }
    }
}
