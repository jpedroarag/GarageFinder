//
//  Vehicle.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct Vehicle: CustomCodable {
    public static var path: String = "/api/v1/vehicles/"
    
    public let id: Int?
    public let model: String?
    public let chassi: String?
    public let licensePlate: String?
    public let year: String?
    public let driverLicense: String?
    public let userId: Int?
    
}
