//
//  CoreDataManager.swift
//  CBL
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import CoreData

class CoreDataManager : NSObject {
    static var shared = CoreDataManager()
    
    private override init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer? = {
        return newPersistentContainer(coreDataModelName: "GarageFinderModel")
    }()
    
    func newPersistentContainer(coreDataModelName name: String = "") -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if error != nil {
                print("CoreData - There was an error (Error while loading persistent stores). \(error!.localizedDescription)")
            }
        })
        return container
    }
    
    // MARK: - View Context of Persistent Container
    func getContext() throws -> NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else { throw CoreDataManagerError.noContainer }
        return context
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        do {
            let context = try getContext()
            if context.hasChanges { try context.save() }
        } catch let error as NSError {
            print("Error saving context. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Delete
    func delete(object: NSManagedObject) {
        do {
            let context = try getContext()
            context.delete(object)
            try context.save()
        } catch let error as NSError {
            print("Error deleting object. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Delete All
    func deleteAll(fromEntity name: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            let context = try getContext()
            try context.execute(request)
            try context.save()
        } catch let error as NSError {
            print("Error deleting data. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Fetch
    func getObjects(forEntity name: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        do {
            let context = try getContext()
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
