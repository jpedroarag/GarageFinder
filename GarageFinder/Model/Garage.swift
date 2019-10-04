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
    public var pictures: [UIImage?]!
    public var average: Float! {
        get {
            var totalRating: Float = 0.0
            comments.forEach { totalRating += $0.rating }
            return comments.isEmpty ? 0.0 : totalRating/Float(comments.count)
        }
        set {}
    }
    
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
        case average
    }
    
    public init(location: CLLocationCoordinate2D) {
        super.init()
        garageId = 0
        name = "IFCE"
        parkingSpaces = 3
        price = Double.random(in: 5...10)
        pictures = [UIImage(named: "mockGarage"), UIImage(named: "mockGarage"), UIImage(named: "mockGarage")]
        user = User(userId: 0, name: "", email: "", documentType: .rg, documentNumber: "", password: "", addresses: [], garages: [self], role: "")
        address = Address(id: 0, zip: "", street: "Rua Treze de Maio", number: "2081", complement: "", city: "", uf: "", coordinate: location, user: user, garage: self)
        comments = []
        (0...5).forEach { _ in
            let random = Double.random(in: 3...5)
            let comment = Comment(title: "Rating", message: "Rating message", rating: Float(random.rounded(toPlaces: 2)))
            comments.append(comment)
        }
    }
    
    public init(id: Int?,
                description: String?,
                parkingSpaces: Int?,
                price: Double?,
                average: Float?,
                user: User?,
                address: Address?,
                comments: [Comment]?,
                pictures: [UIImage]? = []) {
        super.init()
        self.garageId = id
        self.name = description
        self.parkingSpaces = parkingSpaces
        self.price = price
        self.user = user
        self.address = address
        self.comments = comments
        self.pictures = pictures
        self.average = average
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? container.decodeIfPresent(Int.self, forKey: .garageId)
        let name = try? container.decodeIfPresent(String.self, forKey: .name)
        let parkingSpaces = try? container.decodeIfPresent(Int.self, forKey: .parkingSpaces)
        let price = try? container.decodeIfPresent(Double.self, forKey: .price)
        let comments = try? container.decodeIfPresent([Comment].self, forKey: .comments)
        let average = try? container.decodeIfPresent(Float.self, forKey: .average)
        
        var photoUrls = [String]()
        (1...3).forEach { index in
            guard let key = CodingKeys(rawValue: "photo\(index)") else { return }
            if let url = try? container.decodeIfPresent(String.self, forKey: key) {
                photoUrls.append(url)
            }
        }
        
        self.init(id: id, description: name, parkingSpaces: parkingSpaces, price: price, average: average, user: nil, address: nil, comments: comments)
//        self.init(id: id, description: name, parkingSpaces: parkingSpaces, price: price, user: nil, address: address, comments: comments)
        
        let userId = try? container.decodeIfPresent(Int.self, forKey: .user)
        let addressId = try? container.decodeIfPresent(Int.self, forKey: .address)
//        let address = try? container.decodeIfPresent([Address], forKey: .address)
        loadPictures(photoUrls)
        loadUser(userId ?? -1)
        loadAddress(addressId ?? -1)
    }
    
    func loadPictures(_ urls: [String]) {
        // TODO: request pictures
    }
    
    func loadUser(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if user != nil { return }
        // TODO: request user
        completion?()
    }
    
    func loadAddress(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if address != nil { return }
        // TODO: request address
        completion?()
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
