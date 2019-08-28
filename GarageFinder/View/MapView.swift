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
    var rangeCircle: MKCircle!
    
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
    
    func removePinsOutsideRadius() {
        annotations.forEach { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            if !rangeCircle.boundingMapRect.contains(mapPoint) {
                removeAnnotation(pin)
            }
        }
    }
    
    func addRangeCircle(location: CLLocation, meters: Int) {
        rangeCircle = MKCircle(center: location.coordinate, radius: CLLocationDistance(meters))
        addOverlay(rangeCircle)
    }
    
    func removeRangeCircle() {
        guard let circle = rangeCircle else { return }
        removeOverlay(circle)
    }
    
    func updateRangeCircle(location: CLLocation, meters: Int) {
        removeRangeCircle()
        addRangeCircle(location: location, meters: meters)
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
        } else {
            return MKPolylineRenderer()
        }
    }
}
