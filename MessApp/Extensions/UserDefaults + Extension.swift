//
//  UserDefaults + Extension.swift
//  MessApp
//
//  Created by Николай Петров on 05.06.2022.
//

import UIKit

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userLogin
    case defaultName
}

extension UserDefaults {
    public func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    public func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    public func setUserLogin(value: String, completion: (() -> ())? = nil){
        set(value, forKey: UserDefaultsKeys.userLogin.rawValue)
        if completion != nil {
            completion!()
        }
    }
    
    public func getUserLogin() -> String {
        return string(forKey: UserDefaultsKeys.userLogin.rawValue) ?? UserDefaultsKeys.defaultName.rawValue
    }
}
