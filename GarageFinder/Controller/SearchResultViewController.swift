//
//  SearchResultTableViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class SearchResultViewController: UIViewController {

    var matchingItems: [MKMapItem] = []
    var mapView: MapView?
    
    weak var changeScrollViewDelegate: ChangeScrollViewDelegate?
    lazy var searchResultView: SearchResultView = {
        let searchView = SearchResultView(frame: view.frame)
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        return searchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchResultView
    }
    
}

extension SearchResultViewController: SearchDelegate, UISearchBarDelegate {
    func didUpdateSearch(text: String) {
        guard let mapView = mapView else { return }
        
        if text == "" {
            //addEmptyView()
            return
        } else {
            //emptyView.removeFromSuperview()
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                self.matchingItems = []
                self.searchResultView.tableView.reloadData()
                return
            }
            
            self.matchingItems = response.mapItems
            self.searchResultView.tableView.reloadData()
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? ". " : ""
        
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
}

// MARK: - TableViewDataSource
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeScrollViewDelegate?.didChange(scrollView: scrollView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.loadData(name: selectedItem.name, address: parseAddress(selectedItem: selectedItem))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = matchingItems[indexPath.row].placemark.location
        NotificationCenter.default.post(name: .finishSearch, object: location)
        print("category: ", matchingItems[indexPath.row].category)
        //selectMapItemDelegate?.didSelect(item: matchingItems[indexPath.row])
        //finishSearchDelegate?.didFinishSearch()
        self.dismiss(animated: true, completion: nil)
    }
}
