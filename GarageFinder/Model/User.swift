//
//  User.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct User: CustomCodable {
    public static var path: String = "/users/"
    
    public let id: Int
    public let name: String
    public let email: String
    public let documentType: DocumentType
    public let documentNumber: String
    public var password: String?
    public let addresses: [Address]
    public var garages: [Garage]?
    public let role: String
}
