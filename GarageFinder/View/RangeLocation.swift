//
//  Range.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

class RangeLocation {
    
    var userLocation: MKCircle!
    var searchLocation: MKCircle!
    
    init() {
        userLocation = nil
        searchLocation = nil
    }
    
}
