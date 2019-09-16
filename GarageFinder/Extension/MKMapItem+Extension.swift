//
//  MKMapItem+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

extension MKMapItem {
    func retriveCategory(item: MKMapItem) -> [[String: Any]] {
        var categoriesList: [[String: Any]] = []
        if let geoPlace = item.value(forKey: "place") as? NSObject,
            let geoBusiness = geoPlace.value(forKey: "business") as? NSObject,
            let categories = geoBusiness.value(forKey: "localizedCategories") as? [AnyObject] {
            
            if let listCategories = (categories.first as? [AnyObject]) {
                for geoCat in listCategories {
                    if  let level = geoCat.value(forKey: "level") as? Int,
                        let geoLocName = geoCat.value(forKeyPath: "localizedNames") as? NSObject,
                        let name = (geoLocName.value(forKeyPath: "name") as? [String])?.first {
                        categoriesList.append(["level": level, "name": name])
                    }
                }
            }
        }
        
        return categoriesList
    }
}
