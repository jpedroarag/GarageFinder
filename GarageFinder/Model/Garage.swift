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
    public var comments: [Comment]?
//    //public var pictures: [UIImage?]?
//    private var picturesUrls: [String]?
    public var average: Float? = 0.0
    public var favoriteId: Int?
    
    public init(id: Int = 0,
                description: String? = nil,
                parkingSpaces: Int = 0,
                busySpaces: Int = 0,
                price: Double = 0,
                average: Float? = 0.0,
                userId: Int? = nil,
                address: Address? = nil,
                comments: [Comment]? = nil,
                pictures: [UIImage]? = []) {
        self.id = id
        self.description = description
        self.parkingSpaces = parkingSpaces
        self.busySpace = busySpaces
        self.price = price
        self.userId = userId
        self.address = address
        self.comments = comments
//        //self.pictures = pictures
        self.average = average
    }

    func loadPictures(_ urls: [String]) {
        // TODO: request pictures
        //pictures = MockedData.loadMockedPictures()
    }
}
