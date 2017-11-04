//
//  CoreDataManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    // MARK: - Properties. CoreDate Stack
    var modelName: String
    var sqliteName: String
    var options: NSDictionary?    

    var description: String {
        return "context: \(managedObjectContext)\n" + "modelName: \(modelName)" +
            //        "model: \(model.entityVersionHashesByName)\n" +
            //        "coordinator: \(coordinator)\n" +
        "storeURL: \(applicationDocumentsDirectory)\n"
        //        "store: \(store)"
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator     =   NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url             =   self.applicationDocumentsDirectory.appendingPathComponent(self.sqliteName + ".sqlite")
        var failureReason   =   NSLocalizedString("CoreData saved error", comment: "")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: self.options as! [AnyHashable: Any]?)
        } catch {
            var dict                                =   [String: AnyObject]()
            dict[NSLocalizedDescriptionKey]         =   NSLocalizedString("CoreData init error", comment: "") as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey]  =   failureReason as AnyObject?
            dict[NSUnderlyingErrorKey]              =   error as NSError
            let wrappedError                        =   NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()

    
    // MARK: - Class Initialization
    static let instance = CoreDataManager(modelName:  "GiphyAppModel",
                                          sqliteName: "GiphyAppModel",
                                          options:    [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
    
    private init(modelName: String, sqliteName: String, options: NSDictionary? = nil) {
        self.modelName      =   modelName
        self.sqliteName     =   sqliteName
        self.options        =   options
    }
    
    
    // MARK: - Class Functions
    // Save context
    func contextSave() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    // MARK: - CRUD
    // Entity Read
    func entitiesRead(withPredicateParameters predicate: NSPredicate?) -> [ObjectGIF]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ObjectGIF")
        fetchRequest.predicate = predicate

        do {
            return try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [ObjectGIF]
        } catch {
            print(error)
            return nil
        }
    }
    
    // Entity Update
    func entityUpdate(fromGIFObject object: GIFObjectsShowModels.FetchGIFObjects.ViewModel.DisplayedGIFObject) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ObjectGIF")
            fetchRequest.predicate = NSPredicate.init(format: "id == %@", object.id)

            let results = try managedObjectContext.fetch(fetchRequest)
            let entityObjectGIF = (results.count == 0) ? entityCreate() : results.first as! ObjectGIF
            entityObjectGIF.id = object.id
            
//            contextSave()
        } catch {
            print(error)
        }
    }

    // Entity Create
    fileprivate func entityCreate() -> ObjectGIF {
        return NSEntityDescription.insertNewObject(forEntityName: "ObjectGIF", into: managedObjectContext) as! ObjectGIF
    }

/*
    func entityForName(_ entityName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
    }
    
    func fetchedResultsController(_ entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor              =   NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors    =   [sortDescriptor]
        
        let fetchedResultsController    =   NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                       managedObjectContext: managedObjectContext,
                                                                       sectionNameKeyPath: nil,
                                                                       cacheName: nil)
        
        return fetchedResultsController
    }

    // Get Entity by name
    fileprivate func entityDidLoad(byName name: String, andPredicateParameters predicate: NSPredicate?) -> NSManagedObject? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>!
        
        if (predicate == nil) {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        } else {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = predicate
        }
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
            return (results.count == 0) ? self.entityDidCreate(byName: name) : results.first as? NSManagedObject
        } catch {
            print(error)
            
            return nil
        }
    }

    func entitiesDidLoad(byName name: String, andPredicateParameters predicate: NSPredicate?) -> [NSManagedObject]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>!

        if (predicate == nil) {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        } else {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = predicate
        }
        
        do {
            return try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print(error)
            return nil
        }
    }

    func entityBy(_ name: String, andCodeID codeID: String) -> NSManagedObject? {
        return CoreDataManager.instance.entityDidLoad(byName: name, andPredicateParameters: NSPredicate.init(format: "codeID = %@", codeID))
    }

    fileprivate func entityDidCreate(byName name: String) -> NSManagedObject? {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: name, into: self.managedObjectContext)
        
        return newEntity
    }
    
    func entitiesDidRemove(byName name: String, andPredicateParameters predicate: NSPredicate?) {
        guard Connectivity.isNetworkAvailable() else {
            return
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>!

        if (predicate == nil) {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        } else {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = predicate
        }
        
        do {
            let fetchedEntities = try self.managedObjectContext.fetch(fetchRequest)
            
            for entity in fetchedEntities {
                self.managedObjectContext.delete(entity as! NSManagedObject)
            }
        } catch {
            print(error)
        }
    }
 */
}
