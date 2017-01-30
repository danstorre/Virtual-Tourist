//
//  NetworkController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/15/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

struct Network {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var uniqueKeyAccount: String? = nil
    
    // network variables
    var scheme = ""
    var httpheaders : [String:String]? = nil
    var host = ""
    
    // Mark: Get
    func taskForGetMethod(api: Api, params: [String:AnyObject]?, with pathExtension: String? = nil, and json: Data? = nil,completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        
        /* 2. & 3. Build the URL & Configure the request*/
        var request = NSMutableURLRequest(url: createURLFromParameters(params, withPathExtension: pathExtension))
        
        request = createRequest(request: request, method: ConfigurationNetwork.HttpMethods.get, and: json)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 2, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
    }

}


private extension Network {
    
    // MARK:- Helpers
    
    // Create Request
    func createRequest(request : NSMutableURLRequest, method: ConfigurationNetwork.HttpMethods, and jsonBody : Data?) -> NSMutableURLRequest{
        
        request.httpMethod = method.rawValue
        
        
        if let httpheaders = httpheaders {
            for (value,header) in httpheaders {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        
        
        guard let jsonBody = jsonBody else {
            return request
        }
        
        request.httpBody = jsonBody
        
        return request
    }
    
    // create a URL from parameters
    
    func createURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = withPathExtension ?? ""
        
        guard let parameters = parameters else {
            return components.url!
        }
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
     func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
}



