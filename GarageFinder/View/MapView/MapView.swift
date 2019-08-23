//
//  MapView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
    
    lazy var mapView = MKMapView(frame: .zero)
    lazy var locationManager = CLLocationManager()
    lazy var delegate = MapDelegate()
    
    override var frame: CGRect {
        didSet {
            mapView.frame = frame
        }
    }
    
    init(region: MKCoordinateRegion) {
        super.init(frame: .zero)
        configureMapView(region)
        addSubview(mapView)
        locationManager.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    private func configureMapView(_ region: MKCoordinateRegion) {
        mapView.delegate = delegate
        mapView.region = region
        mapView.showsUserLocation = true
    }
    
    private func setConstraints() { }
    
}

extension CLLocationCoordinate2D {
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude)
    }
}
