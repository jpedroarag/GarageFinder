//
//  Garage.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct Garage {
    public let garageId: Int
    public let description: String
    public let parkingSpaces: Int
    public let price: Double
    public let photo1: String
    public let photo2: String
    public let photo3: String
    public let userId: Int
    public let addressId: Int
    public let comments: [Comment]
}
