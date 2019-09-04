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
    lazy var mapShouldFollowUserLocation = true
    
    lazy var mapView = MapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        view.addSubview(mapView)

        title = "Home"
        
        //setupSearchController()
        addFloatingVC()
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        mapView.pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
        setConstraints()
        setupObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
    }
    
    func addFloatingVC() {
        let floatingVC = FloatingViewController()
        self.addChild(floatingVC)
        self.view.addSubview(floatingVC.view)
        floatingVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        floatingVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    func setConstraints() {
        mapView.anchor
        .top(view.topAnchor)
        .right(view.rightAnchor)
        .bottom(view.bottomAnchor)
        .left(view.leftAnchor)
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
    
    func updateNearGarages() {
        mapView.removePinsOutsideRadius()
        let nearGaragesPins = mapView.pins.filter { pin in
            let mapPoint = MKMapPoint(pin.coordinate)
            return mapView.rangeCircle.boundingMapRect.contains(mapPoint)
        }
        mapView.addPins(nearGaragesPins)
    }
    
    @objc func finishSearch(_ notification: Notification) {
        guard let mapItem = notification.object as? MKMapItem else {
            return
        }
        mapShouldFollowUserLocation = false
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        mapView.updateRangeCircle(location: lastLocation, meters: 500)
        updateNearGarages()
        //TODO: Users should choice if maps will follow user location
        //mapView.updateRegion(lastLocation, shouldChangeZoomToDefault: !locationSet, shouldFollowUser: mapShouldFollowUserLocation)
        if !locationSet { locationSet = true }
    }
}

