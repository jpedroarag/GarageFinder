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
    
    var pins = [MKAnnotation]() {
        didSet {
            updateNearGarages(aroundUserLocation: true)
        }
    }
    lazy var range = Range()
    var shownRouteOverlay: MKOverlay?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsUserLocation = true
        mapType = .standard
        showsScale = true
        showsCompass = true
        showsTraffic = true
        tintColor = UIColor(rgb: 0x23D25B, alpha: 100)
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
    
    func updateRegion(_ location: CLLocation, shouldChangeZoomToDefault: Bool = true) {
        if !shouldChangeZoomToDefault { return }
        let newRegion = region(forLocation: location, shouldChangeZoomToDefault: shouldChangeZoomToDefault)
        region = newRegion
    }
    
    func addPin(_ annotation: MKAnnotation) {
        addPins([annotation])
    }
    
    func addPins(_ annotations: [MKAnnotation]) {
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
            let bothRangesAreBeingDisplayed = range.userLocation != nil && range.searchLocation != nil
            if bothRangesAreBeingDisplayed {
                if !range.userLocation.boundingMapRect.contains(mapPoint)
                && !range.searchLocation.boundingMapRect.contains(mapPoint) {
                    removeAnnotation(pin)
                }
            } else {
                let circle: MKCircle! = userLocation ? range.userLocation : range.searchLocation
                if !circle.boundingMapRect.contains(mapPoint) {
                    removeAnnotation(pin)
                }
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
        var rangeToRemove = userLocation ? range.userLocation : range.searchLocation
        if let range = rangeToRemove {
            removeOverlay(range)
            rangeToRemove = nil
        }
    }
    
    func updateRangeCircle(location: CLLocation, meters: Int, userLocation: Bool) {
        removeRangeCircle(userLocation: userLocation)
        addRangeCircle(location: location, meters: meters, userLocation: userLocation)
    }
    
    func updateNearGarages(aroundUserLocation userLocation: Bool) {
        removePinsOutsideRadius(userLocation: userLocation)
        let nearGaragesPins = pins.filter { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            if let circle = (userLocation ? range.userLocation : range.searchLocation) {
                return circle.boundingMapRect.contains(mapPoint)
            }
            return false
        }
        addPins(nearGaragesPins)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        MKDirections(request: directionRequest).calculate { response, error in
            guard let response = response else {
                if let error = error { print("Error: \(error)") }
                return
            }
            
            if let route = response.routes.first {
                if let overlay = self.shownRouteOverlay { self.removeOverlay(overlay) }
                self.shownRouteOverlay = route.polyline
                self.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                self.setRegion(MKCoordinateRegion(route.polyline.boundingMapRect), animated: true)
            }
        }
    }
    
    // MARK: - Render Circle
    func rendererForRangeOverlay(_ overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor(rgb: 0x23D25B, alpha: 100)
        circle.fillColor = UIColor(rgb: 0x23D25B, alpha: 15)
        circle.lineWidth = 0.1
        return circle
    }
    
    func rendererForRouteOverlay(_ overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17, green: 147, blue: 255, alpha: 100)
        renderer.lineWidth = 5.0
        return renderer
    }
    
}
