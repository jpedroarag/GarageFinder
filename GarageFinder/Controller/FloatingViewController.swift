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
    
//    var garageDetailsVC: GarageDetailsViewController?
//    var garageRentingVC: GarageRentingViewController?
    var mapView: MapView?
    
    lazy var floatingView: FloatingView = {
        let floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        floatingView.searchBar.delegate = self
        floatingView.tableView.delegate = self
        floatingView.tableView.dataSource = floatingTableViewDataSource
        return floatingView
    }()
    
    let floatingTableViewDataSource = FloatingTableViewDataSource()
    
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
    }
    
    @objc func finishSearch(_ notification: Notification) {
        floatingView.animTo(positionY: floatingView.partialView)
        cancellSearch()
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
}

extension FloatingViewController: SelectGarageDelegate {
    
    var garageVC: GarageDetailsViewController? {
        return children.filter({ $0 is GarageDetailsViewController}).first as? GarageDetailsViewController
    }
    
    func showGarageDetailsVC() {
        if let garageVC = garageVC {
            garageVC.dismissFromParent()
            showGarageDetailsVC()
        } else {
            let garageDetail = GarageDetailsViewController()
            garageDetail.changeScrollViewDelegate = self
            garageDetail.rentingGarageDelegate = self
            floatingView.floatingViewPositioningDelegate = garageDetail
            floatingView.animTo(positionY: floatingView.middleView)
            show(garageDetail)
        }
        
    }
    
    func didSelectGarage() {
        showGarageDetailsVC()
    }
    
    func didDeselectGarage() {
        if let garageVC = garageVC {
            garageVC.dismissFromParent()
        }
    }
}

extension FloatingViewController: RentingGarageDelegate {
    
    var rentingVC: GarageRentingViewController? {
        return children.filter({ $0 is GarageRentingViewController}).first as? GarageRentingViewController
    }
    
    func showGarageRentingVC(_ garage: Garage) {
        if let rentingVC = rentingVC {
            rentingVC.dismissFromParent()
            showGarageRentingVC(garage)
        } else {
            let garageRenting = GarageRentingViewController()
            garageRenting.garageInfoView.loadData(garage)
            garageRenting.shouldAppearAnimated = false
            show(garageRenting)
            if floatingView.currentPos == floatingView.partialView {
                floatingView.animTo(positionY: floatingView.middleView)
            }
            if let garageVC = garageVC {
                garageVC.dismissFromParent()
            }
        }
    }
    
    func startedRenting(garage: Garage) {
        showGarageRentingVC(garage)
    }
    
    func stoppedRenting() {
        
    }
}

extension FloatingViewController: ChangeScrollViewDelegate {
    func didChange(scrollView: UIScrollView) {
        floatingView.changeCurrentScrollView(scrollView)
    }
}
