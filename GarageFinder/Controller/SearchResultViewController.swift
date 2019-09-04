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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        emptyView.backgroundColor = .white
        return emptyView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.anchor
            .top(view.topAnchor)
            .right(view.rightAnchor)
            .bottom(view.bottomAnchor)
            .left(view.leftAnchor)
        
        addEmptyView()
    }
    
    func addEmptyView() {
        view.addSubview(emptyView)
        emptyView.anchor
            .top(view.topAnchor)
            .right(view.rightAnchor)
            .bottom(view.bottomAnchor)
            .left(view.leftAnchor)
    }

}
extension SearchResultViewController: SearchDelegate {
    func didUpdateSearch(text: String) {
        guard let mapView = mapView else { return }
        
        if text == "" {
            addEmptyView()
            return
        } else {
            emptyView.removeFromSuperview()
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                self.matchingItems = []
                self.tableView.reloadData()
                return
            }
            
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

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        NotificationCenter.default.post(name: .finishSearch, object: matchingItems[indexPath.row])
        
        //selectMapItemDelegate?.didSelect(item: matchingItems[indexPath.row])
        //finishSearchDelegate?.didFinishSearch()
        self.dismiss(animated: true, completion: nil)
    }
}
