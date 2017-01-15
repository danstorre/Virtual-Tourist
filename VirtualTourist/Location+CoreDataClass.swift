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


public class Location: NSManagedObject, MKAnnotation {

    
    struct properties {
        
        static let longitud = "longitud"
        static let latitude = "latitude"
        static let pin = "pin"
    }
    
    public var coordinate: CLLocationCoordinate2D  {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitud)
    }
    
    convenience init(coordinate: CLLocationCoordinate2D, pin: Pin, context: NSManagedObjectContext) {
        
        
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = Double(coordinate.latitude)
            self.longitud = Double(coordinate.longitude)
            self.creationDate = NSDate()
            self.pin = pin
            
            
        } else {
            fatalError("Unable to find Entity name!")
        }
        
    }
    
    
    
}
