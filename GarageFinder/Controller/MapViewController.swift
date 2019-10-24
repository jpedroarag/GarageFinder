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
        return view
    }()
    
    lazy var toolboxView: ToolboxView = {
        let backgroundColor = UIColor(rgb: 0xFFFFFF, alpha: 90)
        let separatorColor = UIColor(rgb: 0xBEBEBE, alpha: 100)
        return ToolboxView(mapView: mapView, backgroundColor: backgroundColor, separatorColor: separatorColor)
    }()
    
    var floatingView: UIView!
    
    weak var selectGarageDelegate: SelectGarageDelegate?
    let provider = URLSessionProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        view.addSubview(toolboxView)
        title = "Home"
        
        mapView.register(GarageAnnotationView.self, forAnnotationViewWithReuseIdentifier: "garagePin")
        
        addFloatingVC()
        
        locationManager.delegate = self
        startUsingDeviceLocation()
        
        setConstraints()
        setupObserver()
        loadGarages()

        if !UserDefaults.tokenIsValid {
            print("Session expired")
            UserDefaults.standard.cleanUser()
        }
    }
    
    func loadGarages() {
        print("loading garages...")
        provider.request(.get(GarageAnnotation.self)) { result in
            switch result {
            case .success(let response):
                if let garages = response.results {
                    self.mapView.pins = garages
                }
            case .failure(let error):
                print("Error getting garages: \(error)")
            }
        }
    }
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
    }
    
    func addFloatingVC() {
        let floatingVC = FloatingViewController()
        floatingVC.mapView = mapView
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
            .top(view.safeAreaLayoutGuide.topAnchor, padding: 8)
            .right(view.rightAnchor, padding: 16)
            //.bottom(floatingView.topAnchor, padding: 16)
            .width(constant: toolboxView.minimumButtonSize.width)
            .height(constant: toolboxView.totalHeight)
    }
    
    func startUsingDeviceLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "garagePin") as? MKMarkerAnnotationView
        annotationView?.titleVisibility = .visible
        annotationView?.subtitleVisibility = .visible
        annotationView?.displayPriority = .required
        annotationView?.canShowCallout = true
        
        if let garageAnnotation = annotation as? GarageAnnotation {
            annotationView?.markerTintColor = garageAnnotation.isAvailable() ? .customGreen : .gray
        }
        return annotationView ?? MKAnnotationView()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let garage = view.annotation as? GarageAnnotation else { return }
        provider.request(.get(Garage.self, id: garage.id)) { result in
            switch result {
            case .success(let response):
                if let selectedGarage = response.result {
                    DispatchQueue.main.async {
                        self.selectGarageDelegate?.didSelectGarage(selectedGarage)
                    }
                }
            case .failure(let error):
                print("Error get garage \(error)")
            }
        }
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
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        switch mode {
        case .none:
            toolboxView.trackerButton.switchToImage(named: "tracker", animated: true)
        case .follow:
            toolboxView.trackerButton.switchToImage(named: "trackerFilled", animated: true)
        case .followWithHeading:
            toolboxView.trackerButton.switchToImage(named: "trackerFilledWithHeading", animated: true)
        @unknown default:
            return
        }
        toolboxView.trackerButton.mode = mode
    }
}
