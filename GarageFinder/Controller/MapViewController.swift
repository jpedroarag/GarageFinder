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
    
    lazy var locationManager = CLLocationManager()
    lazy var locationSet = false
    lazy var mapShouldFollowUserLocation = true
    
    lazy var mapView = MapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        view.addSubview(mapView)
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        mapView.pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
    }
    
    func startUsingDeviceLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func newPin(coordinate: CLLocation, title: String, subtitle: String) -> MKPointAnnotation {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(location: coordinate)
        point.title = title
        point.subtitle = subtitle
        return point
    }
    
    func findGarages() -> [CLLocation] {
        let bundle = Bundle.main
        let path = bundle.url(forResource: "NearGarages", withExtension: "json")!
        let data = try? Data(contentsOf: path, options: .mappedIfSafe)
        if let data = data {
            var locations = [CLLocation]()
            let locationsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Double]]
            locationsDict?.forEach { locationDict in
                let latitude = locationDict["latitude"]!
                let longitude = locationDict["longitude"]!
                let location = CLLocation(latitude: latitude, longitude: longitude)
                locations.append(location)
            }
            return locations
        }
        return []
    }
    
    func updateNearGarages() {
        mapView.removePinsOutsideRadius()
        let nearGaragesPins = mapView.pins.filter { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            return mapView.rangeCircle.boundingMapRect.contains(mapPoint)
        }
        mapView.addPins(nearGaragesPins)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.updateRangeCircle(location: locations.last!, kilometers: 500)
        updateNearGarages()
        mapView.updateRegion(locations.last!, shouldChangeZoomToDefault: !locationSet, shouldFollowUser: mapShouldFollowUserLocation)
        if !locationSet { locationSet = true }
    }
}
