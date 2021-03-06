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

enum APIError: ErrorType {
    case InvalidJSONData
}

struct ResourceAPI {
    private static let baseURLString = "https://swift-resource-api.herokuapp.com"
    
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
    }()
    
    private static func resourceURL(method method: Method, parameters: [String:String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "/": method.rawValue
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
        let url = NSURL(string: "\(baseURLString)/resources")
        return url!
    }
    
    static func resourcesFromJSONData(data: NSData, inContext context: NSManagedObjectContext) -> ResourcesResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let jsonDictionary = jsonObject as? [NSObject:AnyObject],
                resources = jsonDictionary["resources"] as? [String:AnyObject],
                resourcesArray = resources["resource"] as? [[String:AnyObject]] else {
                    return .Failure(APIError.InvalidJSONData)
            }
            var finalResources = [Resource]()
            for resourceJSON in resourcesArray {
                if let resource = resourceFromJSONData(resourceJSON, inContext: context) {
                    finalResources.append(resource)
                }
            }
            if finalResources.count == 0 && resourcesArray.count > 0 {
                return .Failure(APIError.InvalidJSONData)
            }
            return .Success(finalResources)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func resourceFromJSONData(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Resource? {
        guard let
            resourceID = json["_id"] as? String,
            title = json["title"] as? String,
            summary = json["summary"] as? String,
            category = json["category"] as? String,
            is_swift = json["is_swift"] as? Int,
            dateString = json["date_added"] as? String,
            dateAdded = dateFormatter.dateFromString(dateString),
            urlString = json["url"] as? String,
            url = NSURL(string: urlString) else {
                return nil
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Resource")
        let predicate = NSPredicate(format: "resourceID == '\(resourceID)'")
        fetchRequest.predicate = predicate
        
        var fetchedResources: [Resource]!
        context.performBlockAndWait() {
            fetchedResources = try! context.executeFetchRequest(fetchRequest) as! [Resource]
        }
        
        if fetchedResources.count > 0 {
            return fetchedResources.first
        }
        
        var resource: Resource!
        context.performBlock() {
            resource = NSEntityDescription.insertNewObjectForEntityForName("Resource", inManagedObjectContext: context) as! Resource
            resource.title = title
            resource.resourceID = resourceID
            resource.summary = summary
            resource.category = category
            resource.is_swift = is_swift
            resource.dateAdded = dateAdded
            resource.url = url
        }
        
        return resource
        
    }

}