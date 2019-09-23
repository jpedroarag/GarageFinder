//
//  User.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

struct User {
    let userId: Int
    let name: String
    let email: String
    let documentType: DocumentType
    let documentNumber: String
    let password: String
    let addresses: [Address]
    let garages: [Garage]
    let role: String
}
