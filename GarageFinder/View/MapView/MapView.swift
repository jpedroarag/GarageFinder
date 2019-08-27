//
//  MapView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

extension CLLocationCoordinate2D {
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude)
    }
    
    static func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
    
    static func !=(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude != right.latitude || left.longitude != right.longitude
    }
}
