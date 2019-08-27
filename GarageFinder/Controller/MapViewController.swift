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
    lazy var mapView = MKMapView(frame: .zero)
    lazy var pins = [MKPointAnnotation]()
    
    var locationSet = false
    var mapShouldFollowUserLocation = true
    var rangeCircle: MKCircle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        view.addSubview(mapView)
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
    }
    
    func getRegion(forLocation location: CLLocation, shouldChangeZoomToDefault: Bool = true) -> MKCoordinateRegion {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        let zoom = shouldChangeZoomToDefault ? MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) : mapView.region.span
        return MKCoordinateRegion(center: centerCoordinate, span: zoom)
    }
    
    func updateCenter(_ location: CLLocation) {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        mapView.setCenter(centerCoordinate, animated: true)
    }
    
    func updateRegion(_ location: CLLocation, shouldChangeZoomToDefault: Bool = true, shouldFollowUser: Bool = true) {
        if !shouldFollowUser && shouldChangeZoomToDefault { return }
        let region = getRegion(forLocation: location, shouldChangeZoomToDefault: shouldChangeZoomToDefault)
        mapView.region = region
    }
    
    func startUsingDeviceLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addRangeCircle(location: CLLocation, kilometers: Int) {
        rangeCircle = MKCircle(center: location.coordinate, radius: CLLocationDistance(kilometers))
        mapView.addOverlay(rangeCircle)
    }
    
    func removeRangeCircle() {
        guard let circle = rangeCircle else { return }
        mapView.removeOverlay(circle)
    }
    
    func updateRangeCircle(location: CLLocation, kilometers: Int) {
        removeRangeCircle()
        addRangeCircle(location: location, kilometers: kilometers)
    }
    
    func newPin(coordinate: CLLocation, title: String, subtitle: String) -> MKPointAnnotation {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(location: coordinate)
        point.title = title
        point.subtitle = subtitle
        return point
    }
    
    func addPin(_ annotation: MKPointAnnotation) {
        addPins([annotation])
    }
    
    func addPins(_ annotations: [MKPointAnnotation]) {
        let filtered = annotations.filter { annotationToAdd -> Bool in
            !mapView.annotations.contains { annotationAlreadyAdded -> Bool in
                annotationToAdd.coordinate == annotationAlreadyAdded.coordinate
            }
        }
        mapView.addAnnotations(filtered)
    }
    
    func removePinsOutsideRadius() {
        mapView.annotations.forEach { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            if !rangeCircle.boundingMapRect.contains(mapPoint) {
                mapView.removeAnnotation(pin)
            }
        }
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
        removePinsOutsideRadius()
        let nearGaragesPins = pins.filter { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            return rangeCircle.boundingMapRect.contains(mapPoint)
        }
        addPins(nearGaragesPins)
    }
    
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRangeCircle(location: locations.last!, kilometers: 500)
        updateNearGarages()
        updateRegion(locations.last!, shouldChangeZoomToDefault: !locationSet, shouldFollowUser: mapShouldFollowUserLocation)
        if !locationSet { locationSet = true }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}

// Filtro com raio
    // ADD/REM pins
// Mockar as parada
