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
    case conversations = "Conversations_with_"
    case id
}

enum DBMessageField: Int {
    case from = 0
    case text = 1
    case id = 2
}

enum DataBaseError: Error {
    case faiedFetch
}

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    private let database = Database.database().reference()
}

// MARK: - Validate, Insert new user in DataBase

extension DataBaseManager {
    public func validateUser(with login: String, completion: @escaping ((Bool) -> ())) {
        database.child(login).child(DBNames.userLogin.rawValue).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertNewUser(with user: ChatAppUser) {
        let userLogin = DBNames.userLogin.rawValue
        let users = DBNames.users.rawValue
        
        database.child(user.userLogin).setValue([userLogin: user.userLogin])
        
        database.child(users).observeSingleEvent(of: .value) { snaphot in
            if var userCollection = snaphot.value as? [[String: String]] {
                let newElement = [[userLogin: user.userLogin]]
                userCollection.append(contentsOf: newElement)
                self.database.child(users).setValue(userCollection) { error, _ in
                    guard error == nil else { return }
                }
            } else {
                let newCollection = [[userLogin: user.userLogin]]
                self.database.child(users).setValue(newCollection) { error, _ in
                    guard error == nil else { return }
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> ()) {
        database.child(DBNames.users.rawValue).observe(.value) { snapshot in
            
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
                return
            }
            
            let idMessage = Date().getFormattedDate()
            let conversationWith = DBNames.conversations.rawValue
            
            let conversationData = [[DBNames.source.rawValue: currentUser],
                                       [DBNames.message.rawValue: message],
                                       [DBNames.id.rawValue: idMessage]]
            
            if var conversations = userNode["\(conversationWith)\(receiver)"] as? [[[String: String]]] {
                // Append message to conversation
                conversations.append(contentsOf: [conversationData])
                userNode["\(conversationWith)\(receiver)"] = conversations
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                // create new conversation
                userNode["\(conversationWith)\(receiver)"] = [conversationData]
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
}
