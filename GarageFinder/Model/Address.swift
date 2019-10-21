//
//  Address.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import CoreLocation
import GarageFinderFramework

public struct Address: CustomCodable {
    public static var path: String = "/address/"
    
    public var id: Int!
    public var zip: String!
    public var street: String!
    public var number: String!
    public var complement: String!
    public var city: String!
    public var uf: String!
    public var coordinate: CLLocationCoordinate2D!
    public var userId: Int!
    public var garageId: Int!
    
    public init(id: Int?,
                zip: String?,
                street: String?,
                number: String?,
                complement: String?,
                city: String?,
                uf: String?,
                coordinate: CLLocationCoordinate2D?,
                userId: Int? = nil,
                garageId: Int? = nil) {
        self.id = id
        self.zip = zip
        self.street = street
        self.number = number
        self.complement = complement
        self.city = city
        self.uf = uf
        self.coordinate = coordinate
        self.userId = userId
        self.garageId = garageId
    }
}
