//
//  Location.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/13/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
    }
}
