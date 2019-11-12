//
//  Garage.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit
import UIKit.UIImage
import GarageFinderFramework

public struct Garage: CustomCodable {
    public static var path: String = "/api/v1/garages/"
    
    public var id: Int
    public var description: String?
    public var parkingSpaces: Int
    public var busySpace: Int
    public var price: Double
    public var userId: Int?
    public var address: Address?
    public var comments: [Comment]
    var photo1: String?
    var photo2: String?
    var photo3: String?
    public var average: Float? = 0.0
    
    public init(id: Int = 0,
                description: String? = nil,
                parkingSpaces: Int = 0,
                busySpaces: Int = 0,
                price: Double = 0,
                average: Float? = 0.0,
                userId: Int? = nil,
                address: Address? = nil,
                comments: [Comment] = [],
                pictures: [UIImage]? = []) {
        self.id = id
        self.description = description
        self.parkingSpaces = parkingSpaces
        self.busySpace = busySpaces
        self.price = price
        self.userId = userId
        self.address = address
        self.comments = comments
        self.average = average
    }

    func loadPhotos() -> [UIImage] {
        var images: [UIImage] = []
        if let p1 = photo1 {
            if let image = p1.base64Convert() {
                images.append(image)
            }
        }
        if let p2 = photo2 {
            if let image = p2.base64Convert() {
                images.append(image)
            }
        }
        if let p3 = photo3 {
            if let image = p3.base64Convert() {
                images.append(image)
            }
        }
        return images
    }
    
    func loadUserImage(_ completion: ((UIImage?) -> Void)? = nil) {
        URLSessionProvider().request(.get(User.self, id: userId)) { result in
            switch result {
            case .success(let response):
                if let image = response.result?.avatar?.base64Convert() {
                    completion?(image)
                    return
                }
            case .failure(let error):
                print("Error requesting garage owner image: \(error)")
            }
            completion?(UIImage(named: "profile"))
        }
    }
}
