//
//  CLLocationCoordinate2D+Extension.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 28/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
    
    static func != (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude != right.latitude || left.longitude != right.longitude
    }
}

extension CLLocationCoordinate2D: Decodable {
    private enum Keys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}
