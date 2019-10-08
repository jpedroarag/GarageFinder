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
    public var average: Float!
    
    private enum CodingKeys: String, CodingKey {
        case garageId = "garage_id"
        case name = "description"
        case parkingSpaces = "parking_spaces"
        case price
        case photo1
        case photo2
        case photo3
        case user = "user_id"
        case address
        case comments
        case average
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
        let address = try? container.decodeIfPresent(Address.self, forKey: .address)
        self.init(id: id, description: name, parkingSpaces: parkingSpaces, price: price, average: average, user: nil, address: address, comments: comments)
        
        var photoUrls = [String]()
        (1...3).forEach { index in
            guard let key = CodingKeys(rawValue: "photo\(index)") else { return }
            if let url = try? container.decodeIfPresent(String.self, forKey: key) {
                photoUrls.append(url)
            }
        }
        let userId = try? container.decodeIfPresent(Int.self, forKey: .user)
        loadPictures(photoUrls)
        loadUser(userId ?? -1)
    }
    
    func loadPictures(_ urls: [String]) {
        // TODO: request pictures
        pictures = MockedData.loadMockedPictures()
    }
    
    func loadUser(_ id: Int) {
        if id < 0 { return }
        if user != nil { return }
        // TODO: request user
        user = MockedData.loadMockedUser(id)
    }
}

extension Garage: MKAnnotation {
    public var title: String? {
        return NumberFormatter.getPriceString(value: price)
    }
    
    public var subtitle: String? {
        return name
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return address.coordinate
    }
}
