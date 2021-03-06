//
//  OntheMapKitViewDelegate.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/20/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit


let annotationIdentifier = "annotionView"

class MapKitViewDelegateOntheMap: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        UserDefaults.standard.set(mapView.visibleMapRect.origin.x, forKey: "visibleMapRectX")
        UserDefaults.standard.set(mapView.visibleMapRect.origin.y, forKey: "visibleMapRectY")
        UserDefaults.standard.set(mapView.visibleMapRect.size.height, forKey: "visibleMapheight")
        UserDefaults.standard.set(mapView.visibleMapRect.size.width, forKey: "visibleMapwidth")
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        
        guard let mapViewController = navigationController.visibleViewController as? MapViewController else {
            return
        }
        
        mapViewController.performSegue(withIdentifier: "photoAlbum", sender: mapViewController)
        
    }
    
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
