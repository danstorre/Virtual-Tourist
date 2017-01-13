//
//  LocationAnnotation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/23/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit


class LocationAnnotation: NSObject, MKAnnotation {
    
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
