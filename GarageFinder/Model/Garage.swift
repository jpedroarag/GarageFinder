//
//  Garage.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit
import UIKit.UIImage

public class Garage: NSObject, Decodable {
    public var garageId: Int!
    public var name: String! // description
    public var parkingSpaces: Int!
    public var price: Double!
    public var user: User!
    public var address: Address!
    public var comments: [Comment]!
    public var pictures: [UIImage]!
    
    private enum CodingKeys: String, CodingKey {
        case garageId = "garage_id"
        case name = "description"
        case parkingSpaces = "parking_spaces"
        case price
        case photo1
        case photo2
        case photo3
        case user = "user_id"
        case address = "address_id"
        case comments
    }
    
    public var averageRating: Float {
        var totalRating: Float = 0.0
        comments.forEach { totalRating += $0.rating }
        return comments.isEmpty ? 0.0 : totalRating/Float(comments.count)
    }
    
    public init(location: CLLocationCoordinate2D) {
        super.init()
        garageId = 0
        name = ""
        parkingSpaces = 0
        price = 0
        pictures = []
        user = User(userId: 0, name: "", email: "", documentType: .rg, documentNumber: "", password: "", addresses: [], garages: [self], role: "")
        address = Address(addressId: 0, zip: "", street: "", number: "", complement: "", city: "", uf: "", user: user, coordinate: location, garage: self)
        comments = []
    }
    
    public init(id: Int?,
                description: String?,
                parkingSpaces: Int?,
                price: Double?,
                user: User?,
                address: Address?,
                comments: [Comment]?,
                pictures: [UIImage]? = []) {
        self.garageId = id
        self.name = description
        self.parkingSpaces = parkingSpaces
        self.price = price
        self.user = user
        self.address = address
        self.comments = comments
        self.pictures = pictures
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? container.decode(Int.self, forKey: .garageId)
        let name = try? container.decode(String.self, forKey: .name)
        let parkingSpaces = try? container.decode(Int.self, forKey: .parkingSpaces)
        let price = try? container.decode(Double.self, forKey: .price)
        let userId = try? container.decode(Int.self, forKey: .user)
        let addressId = try? container.decode(Int.self, forKey: .address)
//        let address = try? container.decode([Address], forKey: .address)
        let comments = try? container.decode([Comment].self, forKey: .comments)
        
        var photoUrls = [String]()
        (1...3).forEach { index in
            guard let key = CodingKeys(rawValue: "photo\(index)") else { return }
            if let url = try? container.decode(String.self, forKey: key) {
                photoUrls.append(url)
            }
        }
        
        self.init(id: id, description: name, parkingSpaces: parkingSpaces, price: price, user: nil, address: nil, comments: comments)
//        self.init(id: id, description: name, parkingSpaces: parkingSpaces, price: price, user: nil, address: address, comments: comments)
        
        loadPictures(photoUrls)
        loadUser(userId ?? -1)
        loadAddress(addressId ?? -1)
    }
    
    func loadPictures(_ urls: [String]) {
        // TODO: request pictures
    }
    
    func loadUser(_ id: Int) {
        if id < 0 { return }
        // TODO: request user
    }
    
    func loadAddress(_ id: Int) {
        if id < 0 { return }
        // TODO: request address
    }
}

extension Garage: MKAnnotation {
    public var title: String? {
        return name
    }
    
    public var subtitle: String? {
        return "$\(price.rounded(toPlaces: 2))"
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return address.coordinate
    }
}
