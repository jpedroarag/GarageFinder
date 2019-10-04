//
//  User.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public var userId: Int!
    public var name: String!
    public var email: String!
    public var documentType: DocumentType!
    public var documentNumber: String!
    public var password: String!
    public var addresses: [Address]!
    public var garages: [Garage]!
    public var role: String!
}
