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

    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: FavoriteType
    @NSManaged public var categoryString: String
    @NSManaged public var objectId: Int
    @NSManaged public var average: Float
    @NSManaged public var imageBase64: String?
    
    public convenience init() {
        let context = CoreDataManager.shared.context
        let entityDescription = NSEntityDescription.entity(forEntityName: Favorite.entityName, in: context) ?? NSEntityDescription()
        self.init(entity: entityDescription, insertInto: context)
    }
    
    public convenience init(name: String,
                            address: String? = nil,
                            category: PlaceCategory,
                            latitude: Double,
                            longitude: Double,
                            type: FavoriteType,
                            objectId: Int,
                            average: Float = 0,
                            imageBase64: String? = "") {
        self.init()
        self.id = Identifier.nextAvailableIdValue()
        self.name = name
        self.address = address
        self.categoryString = category.rawValue
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.objectId = objectId
        self.average = (type == .garage) ? average : 0
        self.imageBase64 = imageBase64 ?? ""
        Identifier.update()
    }

}
