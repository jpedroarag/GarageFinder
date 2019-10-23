//
//  UserAuth.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct UserAuth: CustomCodable {
    public static var path = "/auth/login/"
    public var email: String?
    public var password: String?
    public var token: String?
    public var exp: Date?
    public var userId: Int?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
