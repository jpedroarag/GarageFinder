//
//  FloatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 29/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {

    weak var searchDelegate: SearchDelegate?
    var garageDetailVC: GarageDetailViewController?
    var mapView: MapView?
    
    lazy var floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var favoriteGarages: [String] = ["Garagem1", "Garagem2", "Garagem3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupFloatingView()
        setupObserver()
    }
    
    func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        floatingView.addGestureRecognizer(gesture)
    }
    
    func setupFloatingView() {
        view = floatingView
        floatingView.searchBar.delegate = self
        floatingView.tableView.dataSource = self
        floatingView.floatingViewPositionDelegate = self
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
extension FloatingViewController: UITableViewDataSource, UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("SCROLLV 1: \(scrollView.contentOffset.y)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Endereços"
        default:
            return "Garagens"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            if let favAddressCell = tableView.dequeueReusableCell(withIdentifier: "FavAddress", for: indexPath) as? FavAddressTableViewCell {
                cell = favAddressCell
            }
        default:
            if let favGaragesCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell {
                favGaragesCell.loadData(titleLabel: "Garagem de Marcus", address: "Av 13 de Maio, 152")
                cell = favGaragesCell
            }
        }

        return cell ?? UITableViewCell()
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
    func showGarageDetailVC() {
        if garageDetailVC == nil {
            garageDetailVC = GarageDetailViewController()
            guard let garageVC = garageDetailVC else { return }
            addChild(garageVC)
            view.addSubview(garageVC.view)
            garageVC.didMove(toParent: self)
            floatingView.animTo(positionY: floatingView.middleView)
        } else {
            removeGarageVC()
            showGarageDetailVC()
        }
    }
    
    func removeGarageVC() {
        garageDetailVC?.removeFromParent()
        garageDetailVC?.view.removeFromSuperview()
        garageDetailVC = nil
    }
    
    func didSelectGarage() {
        showGarageDetailVC()
    }
    
    func didDeselectGarage() {
    
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
