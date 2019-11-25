//
//  User.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct User: CustomCodable {
    public static var path: String = "/api/v1/users/"
    
    public var id: Int?
    public var name: String?
    public var email: String?
    public var documentType: DocumentType?
    public var documentNumber: String?
    public var password: String?
    public var addresses: [Address]?
    public var garages: [Garage]?
    public var role: String?
    public var avatar: String?
    public var playerId: String?

    init(id: Int? = nil, name: String? = nil, email: String? = nil,
         documentType: DocumentType? = nil, documentNumber: String? = nil,
         password: String? = nil, addresses: [Address]? = nil, garages: [Garage]? = nil,
         role: String? = nil, avatar: String? = nil, playerId: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.password = password
        self.addresses = addresses
        self.garages = garages
        self.role = role
        self.avatar = avatar
        self.playerId = playerId
    }
}
