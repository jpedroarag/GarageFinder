//
//  GarageAnnotation.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 17/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit
import GarageFinderFramework

class GarageAnnotation: NSObject, CustomCodable {
    static var path: String = "/api/v1/garages/"
    
    var id: Int
    var parkingSpaces: Int
    var busySpace: Int
    var price: Double
    var lat: String
    var long: String

}

extension GarageAnnotation: MKAnnotation {
    public var title: String? {
        return NumberFormatter.getPriceString(value: price)
    }

    var coordinate: CLLocationCoordinate2D {
        let latitude = Double(lat) ?? 0
        let longitude = Double(long) ?? 0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
