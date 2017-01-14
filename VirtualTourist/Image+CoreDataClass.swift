//
//  Image+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import Foundation
import CoreData


public class Image: NSManagedObject {

    
    convenience init(data: NSData, pin: Pin, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context) {
            self.init(entity: ent, insertInto: context)
            self.pin = pin
            self.creationDate = NSDate()
            self.imageData = data
            
        } else {
            fatalError("Unable to find Entity name!")
        }
        
    }
    
    static func dataImageFrom(dictionary: [String:AnyObject])->NSData?{
        
        
        /* GUARD: Does our photo have a key for 'url_m'? */
        guard let imageUrlString = dictionary[ConstatsFlickrAPI.FlickrResponseKeys.MediumURL] as? String else {
            return nil
        }
        
        // if an image exists at the url, set the image and title
        let imageURL = URL(string: imageUrlString)
        guard let imageData = try? Data(contentsOf: imageURL!) else{
            return nil
        }
        return imageData as NSData
        
    }

    
    static func arrayOfImages(from dictionary: [[String:AnyObject]], for pin: Pin, in context: NSManagedObjectContext){
       
        for imageDic in dictionary{
            
            guard let imageData = dataImageFrom(dictionary: imageDic) else {
                continue
            }
            let _ = Image(data: imageData, pin: pin, context: context)
        }
        
    }

}
