//
//  Address.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import CoreLocation
import GarageFinderFramework

//public struct Address: CustomCodable {
//    public static var path: String = "/api/v1/address/"
//    
//    public var id: Int!
//    public var zip: String!
//    public var street: String!
//    public var number: String!
//    public var complement: String!
//    public var city: String!
//    public var uf: String!
//    public var coordinate: CLLocationCoordinate2D!
//    public var userId: Int!
//    public var garageId: Int!
//    
//    public init(id: Int?,
//                zip: String?,
//                street: String?,
//                number: String?,
//                complement: String?,
//                city: String?,
//                uf: String?,
//                coordinate: CLLocationCoordinate2D?,
//                userId: Int? = nil,
//                garageId: Int? = nil) {
//        self.id = id
//        self.zip = zip
//        self.street = street
//        self.number = number
//        self.complement = complement
//        self.city = city
//        self.uf = uf
//        self.coordinate = coordinate
//        self.userId = userId
//        self.garageId = garageId
//    }
//}

public struct Address: CustomCodable {
    public static var path: String = "/api/v1/address/"
    
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
    
    var description: String? {
        return "\(street ?? ""), \(number ?? "")"
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case zip = "zip"
        case street = "street"
        case number = "number"
        case complement = "complement"
        case city = "city"
        case uf = "uf"
        case lat = "lat"
        case long = "long"
        case userId = "user_id"
        case garageId = "garage_id"
    }
    
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

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(Int.self, forKey: .id)
        let zip = try values.decodeIfPresent(String.self, forKey: .zip)
        let street = try values.decodeIfPresent(String.self, forKey: .street)
        let number = try values.decodeIfPresent(String.self, forKey: .number)
        let complement = try values.decodeIfPresent(String.self, forKey: .complement)
        let city = try values.decodeIfPresent(String.self, forKey: .city)
        let uf = try values.decodeIfPresent(String.self, forKey: .uf)
        let lat = try values.decodeIfPresent(String.self, forKey: .lat)
        let long = try values.decodeIfPresent(String.self, forKey: .long)
        let userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        let garageId = try values.decodeIfPresent(Int.self, forKey: .garageId)
        
        var coord: CLLocationCoordinate2D?
        if let latitude = Double(lat ?? ""), let longitude = Double(long ?? "") {
            coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        self.init(id: id, zip: zip, street: street, number: number, complement: complement,
                  city: city, uf: uf, coordinate: coord, userId: userId, garageId: garageId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(zip, forKey: .zip)
        try container.encodeIfPresent(street, forKey: .street)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(complement, forKey: .complement)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(uf, forKey: .uf)
        
        if let coordinate = coordinate {
            try container.encodeIfPresent("\(coordinate.latitude)", forKey: .lat)
            try container.encodeIfPresent("\(coordinate.longitude)", forKey: .long)
        } else {
            try container.encodeIfPresent("0.0", forKey: .lat)
            try container.encodeIfPresent("0.0", forKey: .long)
        }
        
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(garageId, forKey: .garageId)
    }

}
