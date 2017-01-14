//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var album: NSSet?
    @NSManaged public var location: Location?

}

// MARK: Generated accessors for album
extension Pin {

    @objc(addAlbumObject:)
    @NSManaged public func addToAlbum(_ value: Image)

    @objc(removeAlbumObject:)
    @NSManaged public func removeFromAlbum(_ value: Image)

    @objc(addAlbum:)
    @NSManaged public func addToAlbum(_ values: NSSet)

    @objc(removeAlbum:)
    @NSManaged public func removeFromAlbum(_ values: NSSet)

}
