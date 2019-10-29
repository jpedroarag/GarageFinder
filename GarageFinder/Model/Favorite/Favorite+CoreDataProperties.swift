//
//  Favorite+CoreDataProperties.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit.UIApplication

extension Favorite {
    
    private static var currentId = 1

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: FavoriteType
    @NSManaged public var categoryString: String
    
    public convenience init() {
        let context = CoreDataManager.shared.context
        let entityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: context) ?? NSEntityDescription()
        self.init(entity: entityDescription, insertInto: context)
    }
    
    public convenience init(name: String, category: PlaceCategory, latitude: Double, longitude: Double, type: FavoriteType) {
        self.init()
        self.id = Favorite.currentId
        self.name = name
        self.categoryString = category.rawValue
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        Favorite.currentId += 1
    }

}
