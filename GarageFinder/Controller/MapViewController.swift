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
        
        setupSearchController()
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        mapView.pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
        setConstraints()

    }
    
    func setupSearchController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchResult = SearchResultViewController()
        searchResult.searchDelegate = self
        let searchController = UISearchController(searchResultsController: searchResult)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = searchResult
        definesPresentationContext = true
        
        searchResult.mapView = mapView
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
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        mapView.updateRangeCircle(location: lastLocation, meters: 500, userLocation: true)
        mapView.updateNearGarages(aroundUserLocation: true)
        //TODO: Users should choice if maps will follow user location
        //mapView.updateRegion(lastLocation, shouldChangeZoomToDefault: !locationSet, shouldFollowUser: mapShouldFollowUserLocation)
        if !locationSet { locationSet = true }
    }
}

extension MapViewController: SearchDelegate {
    func didSearch(item: MKMapItem) {
        mapShouldFollowUserLocation = false
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: item.placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
