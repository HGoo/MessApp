//
//  DataBaseManager.swift
//  MessApp
//
//  Created by Николай Петров on 03.06.2022.
//

import Foundation
import FirebaseDatabase

enum DBNames: String {
    case users = "Users"
    case name = "Name"
    case userLogin = "User_login"
    case source = "Message_from"
    case message = "Message"
    case conversations = "conversations_with_"
}

enum DataBaseError: Error {
    case faiedFetch
}

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    private let isOffline = Bool()
    
}

extension DataBaseManager {
    
    public func validateNewUser(with login: String, completion: @escaping ((Bool) -> ())) {
        database.child(login).child(DBNames.userLogin.rawValue).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
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
        database.child(user.userLogin).setValue([DBNames.userLogin.rawValue: user.userLogin])
        
        database.child(DBNames.users.rawValue).observeSingleEvent(of: .value) { snaphot in
            if var userCollection = snaphot.value as? [[String: String]] {
                //append to userdictionary
                let newElement = [
                    [DBNames.userLogin.rawValue: user.userLogin]
                ]
                
                userCollection.append(contentsOf: newElement)
                print("Add in array Users")
                self.database.child(DBNames.users.rawValue).setValue(userCollection) { error, _ in
                    guard error == nil else { return }
                }
            } else {
                //create that dictionary
                let newCollection = [
                    [DBNames.userLogin.rawValue: user.userLogin]
                ]
                print("Add arry Users")
                self.database.child(DBNames.users.rawValue).setValue(newCollection) { error, _ in
                    guard error == nil else { return }
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> ()) {
        database.child(DBNames.users.rawValue).observe(.value) { snapshot in
            
            //print(snapshot.value)
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DataBaseError.faiedFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public func removeAllObservers() {
        database.child(DBNames.users.rawValue).removeAllObservers()
    }
}

//MARK: - Sebding messages/conversations

extension DataBaseManager {
    public func createConversation(with receiver: String,
                                   and sender: String,
                                   message: String,
                                   completion: @escaping (Bool) -> ()) {
        let currentUser = UserDefaults().getUserLogin()
        let ref = database.child(sender)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("User not found")
                return
            }
            
            let newConversationData = [[DBNames.source.rawValue: currentUser],
                                       [DBNames.message.rawValue: message]]
         
            if var conversations = userNode["conversations_with_\(receiver)"] as? [[[String: String]]] {
                //append
                conversations.append(contentsOf: [newConversationData])
                userNode["conversations_with_\(receiver)"] = conversations
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                userNode["conversations_with_\(receiver)"] = [newConversationData]
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }

            }
            
        }
    }
    
    
    public func getMessages(for login: String,
                            with otherUser: String,
                            completion: @escaping (Result<[[[String: String]]], Error>) -> ()) {
        database.child(login).child("\(DBNames.conversations.rawValue)\(otherUser)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[[String: String]]] else {
                completion(.failure(DataBaseError.faiedFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public func getAllMessahesForConversation(with id: String,
                                              completion: @escaping (Result<String, Error>) -> ()) {
        
    }
    
    public func sendMessage(to conversation: String,
                            message: Message,
                            completion: @escaping (Bool) -> ()) {
        
    }
}
