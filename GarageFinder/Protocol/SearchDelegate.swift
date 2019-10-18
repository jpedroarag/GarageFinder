//
//  SearchDelegate.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

protocol SearchDelegate: class {
    func didUpdateSearch(text: String)
}

protocol SelectGarageDelegate: class {
    func didSelectGarage(_ garage: Garage)
    func didDeselectGarage()
    func didDismissGarage()
}
