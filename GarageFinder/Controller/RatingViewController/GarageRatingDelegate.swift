//
//  GarageRatingDelegate.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol GarageRatingDelegate: class {
    func willStartRating()
    func didStartRating(_ garage: Garage)
}
