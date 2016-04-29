//
//  ResourceStore.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import Foundation

enum ResourceResult {
    case Success(Resource)
    case Failure(ErrorType)
}

enum ResourceError: ErrorType {
    case ResourceCreationError
}

class ResourceStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchAllResources(completion completion: (ResourcesResult) -> Void) {
        let url = ResourceAPI.getResources()
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            let result = self.processGetResourcesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processGetResourcesRequest(data data: NSData?, error: NSError?) -> ResourcesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return ResourceAPI.resourcesFromJSONData(jsonData)
    }
}