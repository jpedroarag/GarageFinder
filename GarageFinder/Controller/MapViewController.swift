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
    
    lazy var mapView = MapView(frame: .zero)
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
        
        let backgroundColor = UIColor(rgb: 0x606060, alpha: 90)
        let separatorColor = UIColor(rgb: 0xBBBBBB, alpha: 100)
        toolboxView = ToolboxView(mapView: mapView, backgroundColor: backgroundColor, separatorColor: separatorColor)
        view.addSubview(toolboxView)
        
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
        searchController.searchBar.delegate = searchResult
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

extension MapViewController: SearchDelegate {
    func didSearch(item: MKMapItem) {
        guard let location = item.placemark.location else { return }
        mapView.removeRangeCircle(userLocation: false)
        mapView.addRangeCircle(location: location, meters: 500, userLocation: false)
        mapView.updateNearGarages(aroundUserLocation: false)
        let region = MKCoordinateRegion(mapView.range.searchLocation.boundingMapRect)
        mapView.setRegion(region, animated: true)
    }
}
