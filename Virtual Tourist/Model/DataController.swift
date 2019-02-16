//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 16/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // Create the persistent container
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    // Load the persistent store
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
