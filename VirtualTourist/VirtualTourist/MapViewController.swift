//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/12/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var mapDelegate = MapKitViewDelegateOntheMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        addAnnotions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
    }
    
    
    
}


// MARK :- Helper methods
private extension MapViewController {
    
    func configureMap(){
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.delegate = mapDelegate
        mapView.showsUserLocation = true
    }
    
    // MARK :- Display User
    
    @objc func displayUserLocation(){
        
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            return
        }
        
    }
    
    // MARK :- Add annotions to mapView
    
    func addAnnotions(){
        
        performUIUpdatesOnMain {
            self.indicator.startAnimating()
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
    }
    
}

