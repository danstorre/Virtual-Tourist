//
//  Location+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import Foundation
import CoreData
import MapKit


public class Location: NSManagedObject {

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    convenience init(coordinate: CLLocationCoordinate2D, pin: Pin, context: NSManagedObjectContext) {
        
        
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = Double(coordinate.latitude)
            self.longitud = Double(coordinate.longitude)
            self.pin = pin
            self.creationDate = NSDate()
            
            
        } else {
            fatalError("Unable to find Entity name!")
        }
        
    }
    
    
}
