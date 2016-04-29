//
//  ResourceAPI.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

//
//  ResourceAPI.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import Foundation
import CoreData

enum Method: String {
    case allResources = "resources"
}

enum ResourcesResult {
    case Success([Resource])
    case Failure(ErrorType)
}

enum ResourceError: ErrorType {
    case InvalidJSONData
}

struct ResourceAPI {
    private static let baseURLString = "https://swift-resource-api.herokuapp.com"
    
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func resourceURL(method method: Method, parameters: [String:String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1"
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        
        return components!.URL!
    }
    
    static func getResources() -> NSURL {
        return resourceURL(method: .allResources, parameters: nil)
    }
    
    static func resourcesFromJSONData(data: NSData, inContext context: NSManagedObjectContext) -> ResourcesResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let jsonDictionary = jsonObject as? [NSObject:AnyObject],
                resources = jsonDictionary["resources"] as? [String:AnyObject],
                resourcesArray = resources["resource"] as? [[String:AnyObject]] else {
                    return .Failure(ResourceError.InvalidJSONData)
            }
            
            var finalResources = [Resource]()
            for resourceJSON in resourcesArray {
                if let resource = resourceFromJSONObject(resourcetoJSON, inContext: context) {
                    finalResources.append(resource)
                }
            }
            
            if finalResources.count == 0 && resourcesArray.count > 0 {
                return .Failure(ResourceError.InvalidJSONData)
            }
            return .Success(finalResources)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    static func resourceFromJSONObject(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Resource? {
        guard let
            resourceID = json["id"] as? String,
            title = json["title"] as? String,
            summary = json["summary"] as? String,
            category = json["category"] as? String,
            resourceURLString = json["url"] as? String,
            url = NSURL(string: resourceURLString) else {
            return nil
        }
    
        let fetchRequest = NSFetchRequest(entityName: "Resource")
        let predicate = NSPredicate(format: "resourceID == \(resourceID)")
        fetchRequest.predicate = predicate
        
        var fetchPhotos: [Resource]!
        context.performBlockAndWait() {
            fetchPhotos = try! context.executeFetchRequest(fetchRequest) as! [Resource]
        }
        
        if fetchPhotos.count > 0 {
            return fetchPhotos.first
        }
        
        var resource: Resource!
        context.performBlockAndWait() {
            resource = NSEntityDescription.insertNewObjectForEntityForName("Resource", inManagedObjectContext: context) as! Resource
            resource.name = title
            resource.resourceID = resourceID
            resource.url = url
            resource.summary = summary
            resource.category = category
        }
        return resource
    }
}