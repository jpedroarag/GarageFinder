//
//  MapView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class MapView: MKMapView {
    
    lazy var pins = [MKPointAnnotation]()
    lazy var range = Range()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsUserLocation = true
        delegate = self
        mapType = .standard
        showsScale = true
        showsCompass = true
        showsTraffic = true
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    func region(forLocation location: CLLocation, shouldChangeZoomToDefault: Bool = true) -> MKCoordinateRegion {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        let zoom = shouldChangeZoomToDefault ? MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) : region.span
        return MKCoordinateRegion(center: centerCoordinate, span: zoom)
    }
    
    func updateCenter(_ location: CLLocation) {
        let centerCoordinate = CLLocationCoordinate2D(location: location)
        setCenter(centerCoordinate, animated: true)
    }
    
    func updateRegion(_ location: CLLocation, shouldChangeZoomToDefault: Bool = true, shouldFollowUser: Bool = true) {
        if !shouldFollowUser && shouldChangeZoomToDefault { return }
        let newRegion = region(forLocation: location, shouldChangeZoomToDefault: shouldChangeZoomToDefault)
        region = newRegion
    }
    
    func addPin(_ annotation: MKPointAnnotation) {
        addPins([annotation])
    }
    
    func addPins(_ annotations: [MKPointAnnotation]) {
        let filtered = annotations.filter { annotationToAdd -> Bool in
            !self.annotations.contains { annotationAlreadyAdded -> Bool in
                annotationToAdd.coordinate == annotationAlreadyAdded.coordinate
            }
        }
        addAnnotations(filtered)
    }
    
    func removePinsOutsideRadius(userLocation: Bool) {
        annotations.forEach { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            let circle: MKCircle! = userLocation ? range.userLocation : range.searchLocation
            if !circle.boundingMapRect.contains(mapPoint) {
                removeAnnotation(pin)
            }
        }
    }
    
    func addRangeCircle(location: CLLocation, meters: Int, userLocation: Bool) {
        let circle = MKCircle(center: location.coordinate, radius: CLLocationDistance(meters))
        if userLocation {
            range.userLocation = circle
        } else {
            range.searchLocation = circle
        }
        addOverlay(circle)
    }
    
    func removeRangeCircle(userLocation: Bool) {
        guard let circle = userLocation ? range.userLocation : range.searchLocation else { return }
        removeOverlay(circle)
    }
    
    func updateRangeCircle(location: CLLocation, meters: Int, userLocation: Bool) {
        removeRangeCircle(userLocation: userLocation)
        addRangeCircle(location: location, meters: meters, userLocation: userLocation)
    }
    
    func updateNearGarages(aroundUserLocation userLocation: Bool) {
        removePinsOutsideRadius(userLocation: userLocation)
        let nearGaragesPins = pins.filter { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            let circle: MKCircle! = userLocation ? range.userLocation : range.searchLocation
            return circle.boundingMapRect.contains(mapPoint)
        }
        addPins(nearGaragesPins)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
//        let sourceAnnotation = MKPointAnnotation()
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//        let destinationAnnotation = MKPointAnnotation()
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//
//        showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        MKDirections(request: directionRequest).calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error { print("Error: \(error)") }
                return
            }
            
            if let route = response.routes.first {
                self.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                self.setRegion(MKCoordinateRegion(route.polyline.boundingMapRect), animated: true)
            }
        }
    }
    
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
            renderer.lineWidth = 5.0
            return renderer
        } else {
            return MKPolylineRenderer()
        }
    }
}
