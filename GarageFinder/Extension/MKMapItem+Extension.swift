//
//  MKMapItem+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

extension MKMapItem {
    func retriveCategory() -> [String] {
        var categoriesList: [String] = []
        if let geoPlace = self.value(forKey: "place") as? NSObject,
            let geoBusiness = geoPlace.value(forKey: "business") as? NSObject,
            let categories = geoBusiness.value(forKey: "localizedCategories") as? [AnyObject] {
            
            if let listCategories = (categories.first as? [AnyObject]) {
                for geoCat in listCategories {
                    if  let geoLocName = geoCat.value(forKeyPath: "localizedNames") as? NSObject,
                        let name = (geoLocName.value(forKeyPath: "name") as? [String])?.first {
                        
                        if categoriesList.count <= 1 || !categoriesList.contains(name) {
                            categoriesList.append(name)
                        }
                    }
                }
            }
        }
        
        return categoriesList
    }
}
