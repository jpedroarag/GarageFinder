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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var name: String
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: FavoriteType
    @NSManaged public var categoryString: String
    
    public convenience init(name: String, category: PlaceCategory, latitude: Double, longitude: Double, type: FavoriteType) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
        let context = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: context) ?? NSEntityDescription()
        self.init(entity: entityDescription, insertInto: context)
        
        self.name = name
        self.categoryString = category.rawValue
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
    }

}
