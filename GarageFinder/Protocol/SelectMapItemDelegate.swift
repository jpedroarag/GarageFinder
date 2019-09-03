//
//  SearchDelegate.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

protocol SelectMapItemDelegate: class {
    func didSelect(item: MKMapItem) 
}

protocol FinishSearch: class {
    func didFinishSearch()
}

protocol SearchDelegate: class {
    func didUpdateSearch(text: String)
}
