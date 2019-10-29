//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit
import GarageFinderFramework

class FloatingViewController: UIViewController {

    weak var searchDelegate: SearchDelegate?
    
    var mapView: MapView?
    
    lazy var floatingView: FloatingView = {
        let floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        floatingView.floatingViewPositioningDelegate = self
        floatingView.searchBar.delegate = self
        floatingView.tableView.delegate = self
        floatingView.tableView.dataSource = floatingTableViewDataSource
        return floatingView
    }()
    
    let floatingTableViewDataSource = FloatingTableViewDataSource()
    
    var childAbstractVC: AbstractGarageViewController? {
        return children.filter({ $0 is AbstractGarageViewController}).first as? AbstractGarageViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupObserver()
    }
    
    override func loadView() {
        view = floatingView
    }
    func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        floatingView.addGestureRecognizer(gesture)
    }

    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch(_:)), name: .finishSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentAdjustsMenu(_:)), name: .adjustsMenu, object: nil)
    }
    
    @objc func finishSearch(_ notification: Notification) {
        floatingView.animTo(positionY: floatingView.partialView)
        cancellSearch()
    }
    
    @objc func presentAdjustsMenu(_ notification: Notification) {
        
        let presentVC: UIViewController!
        presentVC = UserDefaults.userIsLogged ? LoginViewController() : LoginViewController()
        present(presentVC, animated: true, completion: nil)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        floatingView.startGesture(recognizer)
    }

}

extension FloatingViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //If the other gesture recognizer is CollectionView, dont recognize simultaneously
        if otherGestureRecognizer.view as? UICollectionView != nil {
            return false
        }
        return true
    }
}

// MARK: TableViewDataSource
extension FloatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = section == 0 ? "Endereços" : "Garagens"
        let headerView = HeaderFavTableView(frame: CGRect(x: 0, y: 0,
                                                          width: tableView.frame.width, height: 50),
                                            title: headerTitle,
                                            image: UIImage(named: "HeartIcon"))
        return headerView
    }
    
    /// MARK: Set the collection view delegate of Addresses
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let favAddressTableViewCell = cell as? FavAddressTableViewCell {
            favAddressTableViewCell.setCollectionViewDelegate(self)
        }
    }
    
    /// MARK: Select a garage
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 { //if the current section is not the address cell
            if let cell = tableView.cellForRow(at: indexPath) as? FavGaragesTableViewCell, let garage = cell.favoriteGarage {
                print("garage selected name: \(garage.name)")
            }
        }
    }
}

extension FloatingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //Button add address action
        } else if let cell = collectionView.cellForItem(at: indexPath) as? FavAddressCollectionViewCell, let address = cell.favoriteAddress {
            let location = CLLocation(latitude: address.latitude, longitude: address.longitude)
            NotificationCenter.default.post(name: .finishSearch, object: location)
            print("address name: \(address.name), latitude: \(address.latitude), longitude: \(address.longitude)")
        }
    }
}

extension FloatingViewController: UISearchBarDelegate {
    func showSearchVC() {
        
        guard let mapVC = self.parent as? MapViewController else { return }
        let searchVC = SearchResultViewController()
        searchVC.mapView = mapVC.mapView
        searchDelegate = searchVC
        searchVC.changeScrollViewDelegate = self
        show(searchVC)

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        floatingView.animTo(positionY: floatingView.fullView)
        searchBar.showsCancelButton = true
        showSearchVC()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first as? SearchResultViewController {
            searchVC.didUpdateSearch(text: searchBar.text ?? "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        floatingView.animTo(positionY: floatingView.middleView)
        cancellSearch()
    }
    
    func cancellSearch() {
        floatingView.clearSearch()
        if let searchVC = self.children.filter({ $0 is SearchResultViewController}).first {
            searchVC.removeFromParent()
            searchVC.view.removeFromSuperview()
        }
    }
    
    func canShowGarageVC(_ vc: AbstractGarageViewController) -> Bool {
        if let viewController = childAbstractVC {
            viewController.dismissFromParent()
            return canShowGarageVC(vc)
        }
        return true
    }
}

extension FloatingViewController: SelectGarageDelegate {
    func didSelectGarage(_ garage: Garage) {
        let garageDetail = GarageDetailsViewController()
        if canShowGarageVC(garageDetail) {
            garageDetail.changeScrollViewDelegate = self
            garageDetail.rentingGarageDelegate = self
            garageDetail.selectGarageDelegate = self
            garageDetail.presentedGarage = garage
            floatingView.floatingViewPositioningDelegate = garageDetail
            show(garageDetail)
            floatingView.animTo(positionY: floatingView.middleView)
        }
    }
    
    func didDeselectGarage() {
        if let abstractVC = childAbstractVC {
            abstractVC.dismissFromParent()
        }
    }
    func didDismissGarage() {
        mapView?.selectedAnnotations.forEach({
            mapView?.deselectAnnotation($0, animated: true)
        })
    }
}

extension FloatingViewController: RentingGarageDelegate {
    var mapViewController: MapViewController? {
        return parent as? MapViewController
    }
    func startedRenting(garage: Garage, parking: Parking, createdNow: Bool) {
        let garageRenting = GarageRentingViewController()
        if canShowGarageVC(garageRenting) {
            mapViewController?.isUserParking = true
            mapViewController?.popupCurrentRentingGaragePin(garage)
            garageRenting.garageRatingDelegate = self
            garageRenting.selectGarageDelegate = self
            garageRenting.garageRentingDelegate = self
            garageRenting.rentedGarage = garage
            garageRenting.parkingObject = parking
            garageRenting.createdNow = createdNow
            show(garageRenting)
            if floatingView.currentIndexPos == 0 {
                floatingView.animTo(positionY: floatingView.middleView)
            }
        }
    }
    
    func stoppedRenting() {
        let parentController = parent as? MapViewController
        if let annotations = parentController?.mapView.annotations {
            parentController?.mapView.removeAnnotations(annotations)
        }
        parentController?.isUserParking = false
        parentController?.loadGarages()
    }
}

extension FloatingViewController: GarageRatingDelegate {
    func willStartRating() {
        floatingView.animTo(positionY: floatingView.fullView)
    }
    func didStartRating(_ garage: Garage) {
        let garageRating = RatingViewController()
        if canShowGarageVC(garageRating) {
            garageRating.selectGarageDelegate = self
            garageRating.currentGarage = garage
            show(garageRating)
            floatingView.animTo(positionY: floatingView.fullView)
        }
    }
    
}

extension FloatingViewController: ChangeScrollViewDelegate {
    func didChange(scrollView: UIScrollView) {
        floatingView.changeCurrentScrollView(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        floatingView.changeCurrentScrollView(scrollView)
    }
}

extension FloatingViewController: FloatingViewPositioningDelegate {
    func didEntered(in position: FloatingViewPosition) {
        if position != .full {
            cancellSearch()
        }
    }
}
