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
    
    init(id: Int, parkingSpaces: Int, busySpace: Int, price: Double, lat: String, long: String) {
        self.id = id
        self.parkingSpaces = parkingSpaces
        self.busySpace = busySpace
        self.price = price
        self.lat = lat
        self.long = long
    }

    func isAvailable() -> Bool {
        return busySpace < parkingSpaces
    }
}

extension GarageAnnotation: MKAnnotation {
    var title: String? {
        return "\(NumberFormatter.getPriceString(value: price))/h"
    }

    var coordinate: CLLocationCoordinate2D {
        let latitude = Double(lat) ?? 0
        let longitude = Double(long) ?? 0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    convenience init?(fromGarage garage: Garage) {
        guard let latitude = garage.address?.coordinate.latitude, let longitude = garage.address?.coordinate.longitude else {
            return nil
        }
        self.init(id: garage.id,
                  parkingSpaces: garage.parkingSpaces,
                  busySpace: garage.busySpace,
                  price: garage.price,
                  lat: "\(latitude)",
                  long: "\(longitude)")
    }
}
