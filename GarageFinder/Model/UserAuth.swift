//
//  UserAuth.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

struct UserAuth: CustomCodable {
    static var path = "/user_token/"
    
    let email: String
    let password: String
}
