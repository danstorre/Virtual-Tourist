//
//  Location+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitud: Double
    @NSManaged public var pin: Pin?

}
