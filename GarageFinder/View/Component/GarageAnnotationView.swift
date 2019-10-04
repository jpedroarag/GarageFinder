//
//  GarageAnnotationView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 03/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

class GarageAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let garage = newValue as? Garage else { return }
            markerTintColor = .black
            glyphText = garage.subtitle ?? ""
        }
    }
}
