//
//  ViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 19/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit
import GarageFinderFramework

class MapViewController: UIViewController {
    
    lazy var locationManager = CLLocationManager()
    lazy var locationSet = false
    
    lazy var mapView: MapView = {
        let view = MapView(frame: .zero)
        view.pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
        return view
    }()
    
    lazy var toolboxView: ToolboxView = {
        let backgroundColor = UIColor(rgb: 0xFFFFFF, alpha: 90)
        let separatorColor = UIColor(rgb: 0xBEBEBE, alpha: 100)
        return ToolboxView(mapView: mapView, backgroundColor: backgroundColor, separatorColor: separatorColor)
    }()
    
    var floatingView: UIView!
    
    weak var selectGarageDelegate: SelectGarageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        view.addSubview(toolboxView)
        title = "Home"
        
        //setupSearchController()
        addFloatingVC()
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        setConstraints()
        setupObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
    }
    
    func addFloatingVC() {
        let floatingVC = FloatingViewController()
        self.floatingView = floatingVC.view
        selectGarageDelegate = floatingVC
        show(floatingVC)
    }
    
    func setConstraints() {
        mapView.anchor
            .top(view.topAnchor)
            .right(view.rightAnchor)
            .bottom(view.bottomAnchor)
            .left(view.leftAnchor)
        toolboxView.anchor
            .right(view.rightAnchor, padding: 16)
            .bottom(floatingView.topAnchor, padding: 16)
            .width(constant: toolboxView.minimumButtonSize.width)
            .height(constant: toolboxView.totalHeight)
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
        guard let path = bundle.url(forResource: "NearGarages", withExtension: "json") else { return [] }
        let data = try? Data(contentsOf: path, options: .mappedIfSafe)
        if let data = data {
            var locations = [CLLocation]()
            let locationsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Double]]
            locationsDict?.forEach { locationDict in
                if let latitude = locationDict["latitude"], let longitude = locationDict["longitude"] {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    locations.append(location)
                }
            }
            return locations
        }
        return []
    }
    
    func openRouteInMaps(sourcePlaceName sourceName: String,
                         sourcePlaceLocation sourceLocation: CLLocation,
                         destinationPlaceName destinationName: String,
                         destinationPlaceLocation destinationLocation: CLLocation) {
        let srcCoord = CLLocationCoordinate2D(location: sourceLocation)
        let srcPlacemark = MKPlacemark(coordinate: srcCoord)
        let source = MKMapItem(placemark: srcPlacemark)
        source.name = sourceName
        
        let destCoord = CLLocationCoordinate2D(location: destinationLocation)
        let destPlacemark = MKPlacemark(coordinate: destCoord)
        let destination = MKMapItem(placemark: destPlacemark)
        destination.name = destinationName
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @objc func finishSearch(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
 
        mapView.removeRangeCircle(userLocation: false)
        mapView.addRangeCircle(location: location, meters: 500, userLocation: false)
        mapView.updateNearGarages(aroundUserLocation: false)
        let region = MKCoordinateRegion(mapView.range.searchLocation.boundingMapRect)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        mapView.updateRangeCircle(location: lastLocation, meters: 500, userLocation: true)
        mapView.updateNearGarages(aroundUserLocation: true)
        if !locationSet {
            mapView.updateRegion(lastLocation, shouldChangeZoomToDefault: true)
            locationSet = true
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectGarageDelegate?.didSelectGarage()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectGarageDelegate?.didDeselectGarage()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            return self.mapView.rendererForRangeOverlay(overlay)
        } else if overlay is MKPolyline {
            return self.mapView.rendererForRouteOverlay(overlay)
        } else {
            return MKPolylineRenderer()
        }
    }
}
