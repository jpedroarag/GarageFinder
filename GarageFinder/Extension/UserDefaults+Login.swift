//
//  UserDefaults+Login.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var isntFirstAccess: Bool {
        return UserDefaults.standard.bool(forKey: "IsntFirstAccess")
    }
    
    static var loggedUserId: Int {
        return UserDefaults.standard.integer(forKey: "LoggedUserId")
    }

    static var token: String {
        return UserDefaults.standard.string(forKey: "Token") ?? ""
    }
    
    static var userIsLogged: Bool {
        return loggedUserId != 0 && token != "" ? true : false
    }
    
    static var playerId: String {
        return UserDefaults.standard.string(forKey: "GT_PLAYER_ID") ?? ""
    }
    
    static var tokenIsValid: Bool {
        if let expDate = UserDefaults.standard.object(forKey: "ExpToken") as? Date {
            if expDate - Date() > 0.0 {
                return true
            }
        }
        return false
    }
    
    func logoutUser() {
        set(0, forKey: "LoggedUserId")
        set(nil, forKey: "Token")
        set(nil, forKey: "ExpToken")
    }
    
    func setValueForLoggedUser(_ value: Any?, forKey key: String) {
        if let value = value {
            let newKey = "\(key)/\(UserDefaults.loggedUserId)"
            UserDefaults.standard.set(value, forKey: newKey)
        }
    }
    
    func valueForLoggedUser(forKey key: String) -> Any? {
        let correctKey = "\(key)/\(UserDefaults.loggedUserId)"
        return UserDefaults.standard.value(forKey: correctKey)
    }
}
