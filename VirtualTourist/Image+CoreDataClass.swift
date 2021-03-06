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

    
    struct properties {
        
        static let creationDate = "creationDate"
        static let imageData = "imageData"
        static let pin = "pin"
        
    }
    
    convenience init(data: NSData? = nil, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context) {
            self.init(entity: ent, insertInto: context)
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

    static func downloadImages(from dictionary: [[String:AnyObject]], withPin pin: Pin, to images: [Image]){
    
        let enumaratedDict = dictionary.enumerated()
        for imageDic in enumaratedDict {
            guard let imageData = dataImageFrom(dictionary: imageDic.element) else {
                continue
            }
            
            let imageFromIndexInImages = images[imageDic.offset]
            imageFromIndexInImages.imageData = imageData
        }
    }
    
    static func arrayOfImages(from dictionary: [[String:AnyObject]], withPin pin: Pin, in context: NSManagedObjectContext){
        var imagesToReturn = [Image]()
        for imageDic in dictionary{
            
            guard let imageData = dataImageFrom(dictionary: imageDic) else {
                continue
            }
            let image = Image(data: imageData, context: context)
            image.pin = pin
            imagesToReturn.append(image)
        }
    }

}
