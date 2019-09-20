//
//  MKMapItem+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import MapKit

/** This function(~=) Match array of strings with string
Examples:
 1.
 ["One", "Two", "Three"] ~= "Tree"
 
 2.
switch ["One", "Two", "Three"] {
case "One":
    print("contains one")
case "Four":
    print("contains four")
case "Six":
   print("contains six")
default:
    break
}
 */
func ~=<T: Equatable>(pattern: T, value: [T]) -> Bool {
    return value.contains(pattern)
}
extension MKMapItem {
    
    var category: PlaceCategory {
        print("all Caregories: ", retrieveCategory)
        
        switch retrieveCategory {
        case "Restaurant":
            return .restaurant
        case "Gym":
            return .gym
        case "Grocery":
            return .grocery
        case "Hospital":
            return .hospital
        case "Education":
            return .education
        case "Hotels & Travel":
            return .hotel
        case "Arts & Entertainment":
            return .entertainanment
        default:
            return .other
        }
    }
    private var retrieveCategory: [String] {
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
