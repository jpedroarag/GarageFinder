//
//  CoreDataManager.swift
//  CBL
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import CoreData

protocol PersistableObject: NSManagedObject {
    associatedtype IdentifierType: Comparable & CVarArg // Int String ...
    static var entityName: String { get } // "Favorite"
    static var idStringSymbol: String { get } // "%d" "%s"
    var id: IdentifierType { get set }
}

class CoreDataManager: NSObject {
    static var shared = CoreDataManager()
    
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GarageFinderModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let loadingError = error {
                print("CORE DATA: Error while loading persistent stores!")
                print("ERROR DESCRIPTION: \(loadingError.localizedDescription)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveChanges() {
        do {
            if context.hasChanges { try context.save() }
        } catch let error as NSError {
            print("Error saving context. \(error), \(error.userInfo)")
        }
    }
    
    func insert<T: PersistableObject>(object: T) {
        var objects = fetch(T.self, sortedReturn: true)
        objects.append(object)
        saveChanges()
    }
    
    func delete<T: PersistableObject>(object: T) {
        let predicate = NSPredicate(format: "(id == \(T.idStringSymbol))", object.id)
        executeDeleteRequest(T.self, withPredicate: predicate)
    }
    
    func deleteAll<T: PersistableObject>(_ entityType: T.Type) {
        executeDeleteRequest(entityType)
    }
    
    func fetch<T: PersistableObject>(_ entityType: T.Type, predicate: NSPredicate? = nil, sortedReturn: Bool = true) -> [T] {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityType.entityName, predicate: predicate)
            let requestResult = try context.fetch(request)
            if let objects = requestResult as? [T] {
                if sortedReturn {
                    return objects.sorted { $0.id < $1.id }
                }
                return objects
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func executeDeleteRequest<T: PersistableObject>(_ entityType: T.Type, withPredicate predicate: NSPredicate? = nil) {
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityType.entityName, predicate: predicate)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try context.execute(request)
            try context.save()
        } catch let error as NSError {
            print("Error deleting data. \(error), \(error.userInfo)")
        }
    }
}

extension NSFetchRequest {
    @objc convenience init(entityName: String, predicate: NSPredicate? = nil) {
        self.init(entityName: entityName)
        self.predicate = predicate
    }
}
