//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class FloatingViewController: UIViewController {

    weak var searchDelegate: SearchDelegate?
    weak var floatingViewPositioningDelegate: FloatingViewPositioningDelegate?
    
    var garageDetailsVC: GarageDetailsViewController?
    var garageRentingVC: GarageRentingViewController?
    var mapView: MapView?
    
    lazy var floatingView: FloatingView = {
        let floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        floatingView.searchBar.delegate = self
        floatingView.tableView.delegate = self
        floatingView.tableView.dataSource = floatingTableViewDataSource
        floatingView.floatingViewPositionDelegate = self
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
        addChild(searchVC)
        floatingView.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)

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
    func showGarageDetailsVC() {
        if garageDetailsVC == nil {
            garageDetailsVC = GarageDetailsViewController()
            garageDetailsVC?.rentingGarageDelegate = self
            guard let garageVC = garageDetailsVC else { return }
            floatingView.floatingViewPositioningDelegate = garageVC
            addChild(garageVC)
            view.addSubview(garageVC.view)
            garageVC.didMove(toParent: self)
            floatingView.animTo(positionY: floatingView.middleView)
        } else {
            removeGarageDetailsVC()
            showGarageDetailsVC()
        }
    }
    
    func removeGarageDetailsVC() {
        garageDetailsVC?.removeFromParent()
        garageDetailsVC?.view.removeFromSuperview()
        garageDetailsVC = nil
    }
    
    func didSelectGarage() {
        showGarageDetailsVC()
    }
    
    func didDeselectGarage() {
    
    }
}

extension FloatingViewController: RentingGarageDelegate {
    func showGarageRentingVC(_ garageInfoView: GarageInfoView) {
        if garageRentingVC == nil {
            garageRentingVC = GarageRentingViewController()
            garageRentingVC?.temporaryGarageView = garageInfoView
            garageRentingVC?.shouldAppearAnimated = false
            guard let rentingVC = garageRentingVC else { return }
            addChild(rentingVC)
            view.addSubview(rentingVC.view)
            rentingVC.didMove(toParent: self)
//            floatingView.animTo(positionY: floatingView.middleView)
        } else {
            removeGarageRentingVC()
            showGarageRentingVC(garageInfoView)
        }
    }
    
    func removeGarageRentingVC() {
        garageRentingVC?.removeFromParent()
        garageRentingVC?.view.removeFromSuperview()
        garageRentingVC = nil
    }
    
    func startedRenting(_ garageInfoView: GarageInfoView) {
        showGarageRentingVC(garageInfoView)
    }
    
    func stoppedRenting() {
        
    }
}

// MARK: FloatingViewPositionDelegate
extension FloatingViewController: FloatingViewPositionDelegate {
    func didChangeFloatingViewPosition() {
        cancellSearch()
    }
    
}

extension FloatingViewController: ChangeScrollViewDelegate {
    func didChange(scrollView: UIScrollView) {
        if floatingView.lastScrollView == scrollView { return }
        floatingView.lastScrollView = scrollView
    }
}
