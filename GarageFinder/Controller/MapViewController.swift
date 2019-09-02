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
    let location = CLLocation(latitude: -3.738394, longitude: -38.551311)
    
    var toolboxView: ToolboxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        view.addSubview(mapView)

        title = "Home"
        
        setupSearchController()
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        mapView.pins = findGarages().map { newPin(coordinate: $0, title: "", subtitle: "") }
        
        let backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let separatorColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        toolboxView = ToolboxView(mapView: mapView, backgroundColor: backgroundColor.withAlphaComponent(0.9), separatorColor: separatorColor)
        view.addSubview(toolboxView)
        
        setConstraints()

        let pin = newPin(coordinate: location, title: "Garagem", subtitle: "Uma garagem qualquer")
        mapView.addAnnotation(pin)
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
        toolboxView.anchor
            .right(view.rightAnchor, padding: 16)
            .bottom(view.bottomAnchor, padding: 16)
            .width(view.widthAnchor, multiplier: 0.15)
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
    
    func openRouteInMaps(sourcePlaceName sourceName: String, destinationPlaceName destinationName: String) {
        if let location = locationManager.location {
            let srcCoord = CLLocationCoordinate2D(location: location)
            let srcPlacemark = MKPlacemark(coordinate: srcCoord)
            let source = MKMapItem(placemark: srcPlacemark)
            source.name = sourceName
            
            let destCoord = CLLocationCoordinate2D(location: self.location)
            let destPlacemark = MKPlacemark(coordinate: destCoord)
            let destination = MKMapItem(placemark: destPlacemark)
            destination.name = destinationName
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
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
