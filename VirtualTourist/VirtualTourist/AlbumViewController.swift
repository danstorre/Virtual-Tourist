//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: CoreDataCollectionViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var mapDelegate = MapViewAlbumDelegateOntheMap()
    
    var pinSelected : Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        mapView.isUserInteractionEnabled = false
        mapView.delegate = mapDelegate
        mapView.addAnnotation(pinSelected!.location!)
        let region = MKCoordinateRegionMake(pinSelected!.location!.coordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        
        let space: CGFloat = 3
        let width = (view.frame.size.width - (3 * space)) / 4.0

        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: 95)
       
        executeSearch()
        // Do any additional setup after loading the view.
    }
    
    // MARK: ACtions
    @IBAction func newAlbumButtonPressed(_ sender: UIButton) {
        let api = FlickrAPI()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let stack = appDelegate.stack
        
        
        api.getPhotosFrom(pin: pinSelected!, savThemIn: stack.context) { (photoAlbum, error) in
            
            guard error == nil else {
                return print(error!.description)
            }
            
            guard let photoAlbum = photoAlbum else {
                return
            }
            
        }
    }
}


extension AlbumViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = fetchedResultsController!.object(at: indexPath) as! Image
        
        // Create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        // Set the name and image
        guard let imageData = image.imageData else {
            return cell
        }
        
        cell.imageView?.image = UIImage(data: imageData as Data)
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
}
