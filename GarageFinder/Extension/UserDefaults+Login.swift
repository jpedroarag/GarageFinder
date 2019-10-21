//
//  UserDefaults+Login.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var loggedUserId: Int {
        return UserDefaults.standard.integer(forKey: "LoggedUserId")
    }

    static var token: String {
        return UserDefaults.standard.string(forKey: "Token") ?? ""
    }
    
    static var userIsLogged: Bool {
        return self.loggedUserId != 0 ? true : false
    }
}
