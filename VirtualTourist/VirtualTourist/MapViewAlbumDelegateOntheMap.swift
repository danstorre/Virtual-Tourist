//
//  MapViewAlbumDelegateOntheMap.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/26/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class MapViewAlbumDelegateOntheMap: NSObject, MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        guard annotation.isKind(of: Location.self) else {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        guard annotationView == nil else {
            return annotationView
        }
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        pinAnnotationView.pinTintColor = UIColor.red
        pinAnnotationView.animatesDrop = true
        pinAnnotationView.canShowCallout = false
        
        
        return pinAnnotationView
    }

    
}
