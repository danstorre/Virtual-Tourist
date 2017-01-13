//
//  PhotoAlbumAPI.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/12/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

final class PhotoAlbumAPI: NSObject {

    
    static let shared = PhotoAlbumAPI()
    
    func getPhotosFrom(location: CLLocationCoordinate2D, completionHandlerForGettingPhotos: @escaping (_ success: Bool, _ errorString: String?) -> Void){

        
    }
}
