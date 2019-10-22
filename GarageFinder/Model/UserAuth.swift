//
//  UserAuth.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct UserAuth: CustomCodable {
    public static var path = "/user_token/"
    public let auth: Credentials
}

public struct Credentials: Codable {
    public let email: String
    public let password: String
}
