//
//  Favorite+CoreDataClass.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Favorite)
public class Favorite: NSManagedObject {
    public var category: PlaceCategory? {
        return PlaceCategory(rawValue: categoryString)
    }
}
