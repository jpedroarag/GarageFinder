//
//  Address.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

public class Address: Decodable {
    public var addressId: Int!
    public var zip: String!
    public var street: String!
    public var number: String!
    public var complement: String!
    public var city: String!
    public var uf: String!
    public var coordinate: CLLocationCoordinate2D!
    public var user: User!
    public var garage: Garage!
    
    public init(id: Int?,
                zip: String?,
                street: String?,
                number: String?,
                complement: String?,
                city: String?,
                uf: String?,
                coordinate: CLLocationCoordinate2D?,
                user: User?,
                garage: Garage?) {
        self.addressId = id
        self.zip = zip
        self.street = street
        self.number = number
        self.complement = complement
        self.city = city
        self.uf = uf
        self.coordinate = coordinate
        self.user = user
        self.garage = garage
    }
}
