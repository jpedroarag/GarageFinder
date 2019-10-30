//
//  Identifier+CoreDataClass.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 29/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Identifier)
public class Identifier: NSManagedObject, PersistableObject {
    public static var entityName: String {
        return "Identifier"
    }
    static var idStringSymbol: String {
        return "%d"
    }
}
