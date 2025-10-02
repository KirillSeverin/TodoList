//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Kirill Severin on 1.10.25.
//
import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(_ context: NSManagedObjectContext? = nil) {
        let contextToSave = context ?? persistentContainer.viewContext
        if contextToSave.hasChanges {
            do {
                try contextToSave.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}
