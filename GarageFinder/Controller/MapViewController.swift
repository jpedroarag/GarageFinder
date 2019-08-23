//
//  ViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 19/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocation(latitude: -3.743993, longitude: -38.535674)
        let region = getRegion(forLocation: location)
        mapView = MapView(region: region)
        mapView.frame = view.frame
        view.addSubview(mapView)
    }
    
    func getRegion(forLocation location: CLLocation) -> MKCoordinateRegion {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        let zoom = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        return MKCoordinateRegion(center: centerCoordinate, span: zoom)
    }
    
    func updateCenter(_ location: CLLocation) {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        mapView.mapView.setCenter(centerCoordinate, animated: true)
    }
    
    func startUsingDeviceLocation() {
        mapView.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.locationManager.requestWhenInUseAuthorization()
        mapView.locationManager.startUpdatingLocation()
    }
    
    func newMarkAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) -> MKPointAnnotation {
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        point.title = title
        point.subtitle = subtitle
        return point
    }
    
}
