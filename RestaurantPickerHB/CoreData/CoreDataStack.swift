//
//  CoreDataStack.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/16/22.
//

import CoreData

class PersistentContainer {
   
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RestaurantModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Could not find core data!")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func newBackgroundContext() -> NSManagedObjectContext {
        let context = PersistentContainer.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
}
