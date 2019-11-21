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
            removeAnnotations(annotations)
            addPins(pins)
        }
    }
    var shownRouteOverlay: MKOverlay?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsUserLocation = true
        showsScale = true
        showsCompass = false
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
    
//    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
//        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
//        
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//        
//        MKDirections(request: directionRequest).calculate { response, error in
//            guard let response = response else {
//                if let error = error { print("Error: \(error)") }
//                return
//            }
//            
//            if let route = response.routes.first {
//                if let overlay = self.shownRouteOverlay { self.removeOverlay(overlay) }
//                self.shownRouteOverlay = route.polyline
//                self.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
//                self.setRegion(MKCoordinateRegion(route.polyline.boundingMapRect), animated: true)
//            }
//        }
//    }
    
    func rendererForRouteOverlay(_ overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17, green: 147, blue: 255, alpha: 100)
        renderer.lineWidth = 5.0
        return renderer
    }
    
}
