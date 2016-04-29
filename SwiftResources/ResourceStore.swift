//
//  ResourceStore.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import Foundation
import CoreData

enum ResourceResult {
    case Success([Resource])
    case Failure(ErrorType)
}

enum ResourceError: ErrorType {
    case ResourceCreationError
}

class ResourceStore {
    
    let coreDataStack = CoreDataStack(modelName: "Resource")
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchAllResources(completion completion: (ResourcesResult) -> Void) {
        let url = ResourceAPI.getResources()
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            var result = self.processGetResourcesRequest(data: data, error: error)
            if case let .Success(resources) = result {
                let mainQueueContext = self.coreDataStack.mainQueueContext
                mainQueueContext.performBlock(){
                    try! mainQueueContext.obtainPermanentIDsForObjects(resources)
                }
                
                let objectIDs = resources.map{ $0.objectID }
                let predicate = NSPredicate(format: "self in %@", objectIDs)
                let sortByDateAdded = NSSortDescriptor(key: "dateAdded", ascending: true)
                
                do {
                    try self.coreDataStack.saveChanges()
                    let mainQueueResources = try self.fetchMainQueueResources(predicate: predicate, sortDescriptors: [sortByDateAdded])
                    result = .Success(mainQueueResources)
                } catch let error {
                    result = .Failure(error)
                }
            }
            completion(result)
        }
        task.resume()
    }
    
    func processGetResourcesRequest(data data: NSData?, error: NSError?) -> ResourcesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return ResourceAPI.resourcesFromJSONData(jsonData, inContext: self.coreDataStack.mainQueueContext)
    }
    
    func fetchMainQueueResources(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Resource] {
        let fetchRequest = NSFetchRequest(entityName: "Resource")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueResources: [Resource]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueueResources = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Resource]
            }
            catch let error {
                fetchRequestError = error
            }
        }
        
        guard let resources = mainQueueResources else {
            throw fetchRequestError!
        }
        return resources
    }
}