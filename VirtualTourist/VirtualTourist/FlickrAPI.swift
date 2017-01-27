//
//  ParseApiController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit
import CoreData


protocol PhotoAlbumProtocol {
    
    
    func getPhotosFrom(pin: Pin, savThemIn context: NSManagedObjectContext, completionHandlerForGettingPhotos: @escaping (_ arrayImages: [[String: AnyObject]]?, _ error: NSError?) -> Void)
    func getRandomPhoto(from pin: Pin, savThemIn context: NSManagedObjectContext, completionHandlerForGettingPhotos: @escaping (_ arrayImages: [Image]?, _ error: NSError?) -> Void)
    
}


final class FlickrAPI: Api, PhotoAlbumProtocol {
    
    
    static let shared = FlickrAPI()
    
    override init(){
        super.init()
        self.networkController.host = ConstatsFlickrAPI.Base.host
        self.networkController.scheme = ConstatsFlickrAPI.Base.scheme
        
    }
    
    // MARK:- Get Student Location
    
    func getRandomPhoto(from pin: Pin, savThemIn context: NSManagedObjectContext,completionHandlerForGettingPhotos: @escaping ([Image]?, NSError?) -> Void) {
        
    }
    
    func getPhotosFrom(pin: Pin, savThemIn context: NSManagedObjectContext, completionHandlerForGettingPhotos: @escaping ([[String: AnyObject]]?, NSError?) -> Void) {
    
        
        let parameters = [
            ConstatsFlickrAPI.FlickrParameterKeys.Method: ConstatsFlickrAPI.FlickrParameterValues.SearchMethod,
            ConstatsFlickrAPI.FlickrParameterKeys.APIKey: ConstatsFlickrAPI.FlickrParameterValues.APIKey,
            ConstatsFlickrAPI.FlickrParameterKeys.BoundingBox: bboxString(location: pin.location!.coordinate),
            ConstatsFlickrAPI.FlickrParameterKeys.per_page: 20,
            ConstatsFlickrAPI.FlickrParameterKeys.SafeSearch: ConstatsFlickrAPI.FlickrParameterValues.UseSafeSearch,
            ConstatsFlickrAPI.FlickrParameterKeys.Extras: ConstatsFlickrAPI.FlickrParameterValues.MediumURL,
            ConstatsFlickrAPI.FlickrParameterKeys.Format: ConstatsFlickrAPI.FlickrParameterValues.ResponseFormat,
            ConstatsFlickrAPI.FlickrParameterKeys.NoJSONCallback: ConstatsFlickrAPI.FlickrParameterValues.DisableJSONCallback
        ] as [String : Any]
        
        networkController.taskForGetMethod(api: self, params: parameters as [String:AnyObject], with: ConstatsFlickrAPI.Base.path, completionHandlerForGET: { (parsedResult, error) in
        
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGettingPhotos(nil, NSError(domain: "getStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("getStudentLocation returns an error")
            }
            
            guard let parsedResult = parsedResult else {
                return sendError("no parsed result returned from network")
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[ConstatsFlickrAPI.FlickrResponseKeys.Status] as? String, stat == ConstatsFlickrAPI.FlickrResponseValues.OKStatus else {
                sendError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "photos" key in our result? */
            guard let photosDictionary = parsedResult[ConstatsFlickrAPI.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                sendError("Cannot find key '\(ConstatsFlickrAPI.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let photosArray = photosDictionary[ConstatsFlickrAPI.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                sendError("Cannot find key '\(ConstatsFlickrAPI.FlickrResponseKeys.Photo)' in \(photosDictionary)")
                return
            }
            
            completionHandlerForGettingPhotos(photosArray, nil)
            
        })
        
    }
}

private extension FlickrAPI {

    func bboxString(location: CLLocationCoordinate2D) -> String {
        // ensure bbox is bounded by minimum and maximums
        let latitude = location.latitude, longitude = location.longitude
        
        let minimumLon = max(longitude - ConstatsFlickrAPI.Base.SearchBBoxHalfWidth, ConstatsFlickrAPI.Base.SearchLonRange.0)
        let minimumLat = max(latitude - ConstatsFlickrAPI.Base.SearchBBoxHalfHeight, ConstatsFlickrAPI.Base.SearchLatRange.0)
        let maximumLon = min(longitude + ConstatsFlickrAPI.Base.SearchBBoxHalfWidth, ConstatsFlickrAPI.Base.SearchLonRange.1)
        let maximumLat = min(latitude + ConstatsFlickrAPI.Base.SearchBBoxHalfHeight, ConstatsFlickrAPI.Base.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        
    }
    
}
