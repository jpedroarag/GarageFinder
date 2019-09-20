//
//  FavoriteGarage.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

struct Favorite {
    let name: String
    let address: String? = nil
    let category: PlaceCategory
    let latitude: Double
    let longitude: Double
    let type: FavoriteType
}

enum FavoriteType {
    case garage
    case address
}
