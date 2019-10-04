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
    
    private enum CodingKeys: String, CodingKey {
        case addressId = "address_id"
        case zip
        case street
        case number
        case complement
        case city
        case uf
        case coordinate
        case user = "user_id"
        case garage = "garage_id"
    }
    
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
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? container.decodeIfPresent(Int.self, forKey: .addressId)
        let zip = try? container.decodeIfPresent(String.self, forKey: .zip)
        let street = try? container.decodeIfPresent(String.self, forKey: .street)
        let number = try? container.decodeIfPresent(String.self, forKey: .number)
        let complement = try? container.decodeIfPresent(String.self, forKey: .complement)
        let city = try? container.decodeIfPresent(String.self, forKey: .city)
        let uf = try? container.decodeIfPresent(String.self, forKey: .uf)
        let coordinate = try? container.decodeIfPresent(CLLocationCoordinate2D.self, forKey: .coordinate)
        self.init(id: id, zip: zip, street: street, number: number, complement: complement, city: city, uf: uf, coordinate: coordinate, user: nil, garage: nil)
        
        let userId = try? container.decodeIfPresent(Int.self, forKey: .user)
        let garageId = try? container.decodeIfPresent(Int.self, forKey: .garage)
        loadUser(userId ?? -1)
        loadGarage(garageId ?? -1)
    }
    
    func loadUser(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if user != nil { return }
        // TODO: request user
        completion?()
    }
    
    func loadGarage(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if garage != nil { return }
        // TODO: request address
        completion?()
    }
}

extension CLLocationCoordinate2D: Decodable {
    private enum Keys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}
