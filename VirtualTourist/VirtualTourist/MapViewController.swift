//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/12/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var mapDelegate = MapKitViewDelegateOntheMap()
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGR.minimumPressDuration = 1.6
        mapView.addGestureRecognizer(longPressGR)
    }
    
    // MARK :- Gesture Methods
    
    @objc
    func handleLongPress(gestureRecognizer: UIGestureRecognizer){
    
        guard gestureRecognizer.state == .began else {
            return
        }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinatesFromTouch = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        let newPin = Pin(context: stack.context)
        let location = Location(coordinate: coordinatesFromTouch, pin: newPin, context: stack.context)
        location.pin = newPin
        stack.save()
    }
    
    
    // MARK :- Add annotions to mapView
    
    func addAnnotions(){
        
        performUIUpdatesOnMain {
            self.indicator.startAnimating()
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        executeSearch()
        
        performUIUpdatesOnMain {
            self.indicator.stopAnimating()
            for pin in self.fetchedResultsController!.fetchedObjects!{
                guard let pin = pin as? Pin else {
                    continue
                }
                
                guard let location = pin.location else {
                    continue
                }
                
                self.mapView.addAnnotation(location)
            }
        }
        
    }
    
}

extension MapViewController{

    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
}

// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

extension MapViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        performUIUpdatesOnMain {
        switch(type) {
        case .insert:
            guard let pin = anObject as? Pin else {
                return
            }
            self.mapView.addAnnotation(pin.location!)
        case .delete: break
            //collectionView?.deleteItems(at: [indexPath!])
        case .update: break
            //collectionView?.reloadItems(at: [indexPath!])
        case .move: break
//            collectionView?.deleteItems(at: [indexPath!])
//            collectionView?.insertItems(at: [newIndexPath!])
        }
        }
    }
    
}

