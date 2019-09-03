//
//  SearchResultTableViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

class SearchResultViewController: UITableViewController {

    var matchingItems: [MKMapItem] = []
    var mapView: MapView?
    weak var searchDelegate: SelectMapItemDelegate?
    weak var finishSearchDelegate: FinishSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.bounces = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
        }
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.loadData(name: selectedItem.name, address: parseAddress(selectedItem: selectedItem))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDelegate?.didSelect(item: matchingItems[indexPath.row])
        finishSearchDelegate?.didFinishSearch()
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SearchResultViewController: SearchDelegate {
    func didUpdateSearch(text: String) {
        guard let mapView = mapView else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
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
}
