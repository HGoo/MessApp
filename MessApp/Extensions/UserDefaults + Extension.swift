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
}

extension UserDefaults {
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    //MARK: Save User Data
    func setUserLogin(value: String){
        set(value, forKey: UserDefaultsKeys.userLogin.rawValue)
        synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserLogin() -> String{
        return string(forKey: UserDefaultsKeys.userLogin.rawValue) ?? "NoName"
    }
}
