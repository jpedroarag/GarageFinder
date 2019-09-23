//
//  Garage.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

struct Garage {
    let garageId: Int
    let description: String
    let parkingSpaces: Int
    let price: Double
    let photo1: String
    let photo2: String
    let photo3: String
    let userId: Int
    let addressId: Int
    let comments: [Comment]
}
