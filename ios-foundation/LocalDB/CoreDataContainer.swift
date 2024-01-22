//
//  CoreDataContainer.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import Foundation
import CoreData

class CoreDataContainer {
    
    private init() {}
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ios_foundation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    class func saveContext(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let context = CoreDataContainer.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch {
                let nserror = error as NSError
                completion(.failure(error))
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
