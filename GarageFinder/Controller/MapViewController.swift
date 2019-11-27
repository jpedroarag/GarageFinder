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
    lazy var isUserParking = false
    lazy var lastTrackingMode = MKUserTrackingMode.none
    
    lazy var mapView: MapView = {
        let view = MapView(frame: .zero)
        let mapOption = UserDefaults.standard.valueForLoggedUser(forKey: "MapOption") as? String
        let isOn = UserDefaults.standard.valueForLoggedUser(forKey: "TrafficOption") as? Bool
        view.mapType = (mapOption == "Satélite") ? .hybrid : .mutedStandard
        view.showsTraffic = isOn ?? false
        return view
    }()
    
    lazy var adjustsButton = AdjustsButton(frame: .zero)
    lazy var trackerButton = TrackerButton(mapView: mapView)
    
    lazy var toolboxView: ToolboxView = {
        let backgroundColor = UIColor(rgb: 0xFFFFFF, alpha: 90)
        let separatorColor = UIColor(rgb: 0xBEBEBE, alpha: 100)
        return ToolboxView(withBackgroundColor: backgroundColor,
                           withSeparatorColor: separatorColor,
                           andButtons: self.adjustsButton, self.trackerButton)
    }()
    
    var floatingView: UIView!
    var floatingViewController = FloatingViewController()
    
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
        setupObservers()

        if !UserDefaults.tokenIsValid {
            UserDefaults.standard.logoutUser()
        }
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showIntro()
    }
    
    func showIntro() {
        if !UserDefaults.isntFirstAccess {
            UserDefaults.standard.set(true, forKey: "IsntFirstAccess")
            let introVC = IntroViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            introVC.modalPresentationStyle = .fullScreen
            present(introVC, animated: true, completion: nil)
         }
    }
    
    func popupCurrentRentingGaragePin(_ garage: Garage) {
        if let annotation = GarageAnnotation(fromGarage: garage) {
            self.mapView.removeAnnotations(mapView.pins)
            self.mapView.addPin(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func isUserParking(_ completion: @escaping (Parking?) -> Void) {
        if UserDefaults.userIsLogged && UserDefaults.tokenIsValid {
            provider.request(.getCurrent(Parking.self)) { result in
                switch result {
                case .success(let response):
                    completion(response.result)
                case .failure(let error):
                    print("Error requesting current parking: \(error)")
                }
            }
        } else {
            loadGarages()
        }
    }
    
    func requestCurrentParkingGarage(id: Int, _ completion: @escaping (Garage?) -> Void) {
        self.provider.request(.get(Garage.self, id: id)) { result in
            switch result {
            case .success(let response):
                completion(response.result)
            case .failure(let error):
                print("Error requesting current parking: \(error)")
            }
        }
    }
    
    func loadGarages() {
        let loadingView = LoadingView(message: "Carregando garagens")
        view.addSubview(loadingView)
        print("loading garages...")
        provider.request(.get(GarageAnnotation.self)) { result in
            switch result {
            case .success(let response):
                if let garages = response.results {
                    DispatchQueue.main.async {
                        self.mapView.pins = garages
                        loadingView.dismissIndicator()
                    }
                }
            case .failure(let error):
                print("Error getting garages: \(error)")
                loadingView.dismissIndicator()
            }
        }
    }
    
    @objc func updateMapType(_ sender: Notification) {
        let mapOption: String?
        if UserDefaults.userIsLogged {
            mapOption = UserDefaults.standard.valueForLoggedUser(forKey: "MapOption") as? String
        } else {
            mapOption = sender.object as? String
        }
        mapView.mapType = (mapOption == "Satélite") ? .hybrid : .mutedStandard
    }
    
    @objc func updateMapTraffic(_ sender: Notification) {
        let isOn: Bool?
        if UserDefaults.userIsLogged {
            isOn = UserDefaults.standard.valueForLoggedUser(forKey: "TrafficOption") as? Bool
        } else {
            isOn = sender.object as? Bool
        }
        mapView.showsTraffic = isOn ?? false
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapType(_:)), name: .mapOptionSettingDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapTraffic(_:)), name: .trafficSettingDidChange, object: nil)
    }
    
    func addFloatingVC() {
        floatingViewController.mapView = mapView
        self.floatingView = floatingViewController.view
        selectGarageDelegate = floatingViewController
        show(floatingViewController)
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
            .width(constant: toolboxView.minimumButtonSize.width)
            .height(constant: toolboxView.totalHeight)
    }
    
    func startUsingDeviceLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
//    func openRouteInMaps(sourcePlaceName sourceName: String,
//                         sourcePlaceLocation sourceLocation: CLLocation,
//                         destinationPlaceName destinationName: String,
//                         destinationPlaceLocation destinationLocation: CLLocation) {
//        let srcCoord = CLLocationCoordinate2D(location: sourceLocation)
//        let srcPlacemark = MKPlacemark(coordinate: srcCoord)
//        let source = MKMapItem(placemark: srcPlacemark)
//        source.name = sourceName
//
//        let destCoord = CLLocationCoordinate2D(location: destinationLocation)
//        let destPlacemark = MKPlacemark(coordinate: destCoord)
//        let destination = MKMapItem(placemark: destPlacemark)
//        destination.name = destinationName
//
//        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//    }
    
    @objc func finishSearch(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(location: location), span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
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
        if isUserParking { return }
        guard let garage = view.annotation as? GarageAnnotation else { return }
        let loadingView = LoadingView(message: "Carregando garagem")
        self.view.addSubview(loadingView)
        provider.request(.get(Garage.self, id: garage.id)) { result in
            switch result {
            case .success(let response):
                if let selectedGarage = response.result {
                    DispatchQueue.main.async {
                        self.selectGarageDelegate?.didSelectGarage(selectedGarage)
                        loadingView.dismissIndicator()
                    }
                }
            case .failure(let error):
                print("Error get garage \(error)")
                loadingView.dismissIndicator()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let garage = view.annotation as? GarageAnnotation else { return }
        if isUserParking {
            mapView.selectAnnotation(garage, animated: true)
            return
        }
        selectGarageDelegate?.didDeselectGarage()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKPolyline:
            return self.mapView.rendererForRouteOverlay(overlay)
        default:
            return MKPolylineRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        trackerButton.switchToImage(named: "tracker(\(mode.rawValue))", animated: lastTrackingMode.rawValue != 2)
        trackerButton.mode = mode
        lastTrackingMode = mode
    }
}

extension MapViewController: ParkingStatusDelegate {
    func loadData(fromLogin: Bool = false) {
        isUserParking { result in
            if let parking = result, let ownerAccepted = parking.status {
                if ownerAccepted {
                    self.isUserParking = true
                    self.requestCurrentParkingGarage(id: parking.garageId ?? 0) { result in
                        if let garage = result {
                            DispatchQueue.main.async {
                                self.popupCurrentRentingGaragePin(garage)
                                self.floatingViewController.startedRenting(garage: garage,
                                                                           parking: parking,
                                                                           createdNow: false)
                            }
                        }
                    }
                }
            } else {
                if !fromLogin {
                    DispatchQueue.main.async {
                        self.loadGarages()
                    }
                }
            }
        }
    }
    
    func dismissRenting() {
        let floatingChildrenFiltered = floatingViewController.children.filter { $0.isKind(of: GarageRentingViewController.self) }
        let rentingController = floatingChildrenFiltered.first as? AbstractGarageViewController
        rentingController?.dismissFromParent()
        floatingViewController.stoppedRenting()
    }
}
