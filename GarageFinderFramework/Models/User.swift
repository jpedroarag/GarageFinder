//
//  User.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct User {
    public let userId: Int
    public let name: String
    public let email: String
    public let documentType: DocumentType
    public let documentNumber: String
    public let password: String
    public let addresses: [Address]
    public let garages: [Garage]
    public let role: String
}
