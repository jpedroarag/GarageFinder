//
//  Identifier+CoreDataProperties.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 29/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
//

import Foundation
import CoreData

extension Identifier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identifier> {
        return NSFetchRequest<Identifier>(entityName: "Identifier")
    }

    @NSManaged public var id: Int
    
    private convenience init() {
        let context = CoreDataManager.shared.context
        let entityDescription = NSEntityDescription.entity(forEntityName: Identifier.entityName, in: context) ?? NSEntityDescription()
        self.init(entity: entityDescription, insertInto: context)
    }
    
    private convenience init(currentValue: Int) {
        self.init()
        self.id = 1
    }
    
    public static func nextAvailableIdValue() -> Int {
        if let identifier = CoreDataManager.shared.fetch(Identifier.self).first {
            return identifier.id
        } else {
            let identifier = Identifier()
            CoreDataManager.shared.saveChanges()
            return identifier.id
        }
    }
    
    public static func update() {
        if let identifier = CoreDataManager.shared.fetch(Identifier.self).first {
            identifier.id += 1
            CoreDataManager.shared.saveChanges()
        }
    }

}
