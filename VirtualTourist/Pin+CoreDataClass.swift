//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Pin: NSManagedObject {
    
    struct properties {
    
        static let album = "album"
        static let location = "location"
    }

    convenience init(context: NSManagedObjectContext) {
        
        if let pinEnt = NSEntityDescription.entity(forEntityName: "Pin", in: context)  {
            self.init(entity: pinEnt, insertInto: context) 
            self.creationDate = NSDate()
            
            
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}
