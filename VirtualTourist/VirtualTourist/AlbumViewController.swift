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
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var mapDelegate = MapViewAlbumDelegateOntheMap()
    
    var pinSelected : Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureCollectionView()
        navigationController?.isNavigationBarHidden = false
        executeSearch()
        
        guard let album = pinSelected!.album else {
            return downloadImages()
        }
        
        if album.count == 0 {
            noImagesLabel.isHidden = false
            downloadImages()
            downloadButton.isEnabled = false
            downloadButton.isUserInteractionEnabled = false
        }else{
            noImagesLabel.isHidden = true
            downloadButton.isEnabled = true
            downloadButton.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: ACtions
    @IBAction func newAlbumButtonPressed(_ sender: UIButton) {
        
        
        for indexp in collectionView.indexPathsForVisibleItems {
            if let context = fetchedResultsController?.managedObjectContext,
                let image = fetchedResultsController?.object(at: indexp) as? Image
            {
                context.delete(image)
            }
        }
        downloadImages()
        downloadButton.isEnabled = false
        downloadButton.isUserInteractionEnabled = false
    }
}

extension AlbumViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let context = fetchedResultsController?.managedObjectContext,
           let image = fetchedResultsController?.object(at: indexPath) as? Image
        {
            context.delete(image)
        }
    }
}

extension AlbumViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = fetchedResultsController!.object(at: indexPath) as! Image
        
        // Create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        // Set the image
        guard let imageData = image.imageData else {
            cell.imageView?.image = #imageLiteral(resourceName: "placeholder")
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        }
        
        cell.imageView?.image = UIImage(data: imageData as Data)
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    //MARK:- Photo Methods
    
    func downloadImages(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let stack = appDelegate.stack
        
        FlickrAPI.shared.getPhotosFrom(pin: self.pinSelected!, savThemIn: stack.context) { (photoAlbum, error) in
            
            guard error == nil else {
                return print(error!.description)
            }
            
            guard let photoAlbum = photoAlbum else {
                return
            }
            
            self.performUIUpdatesOnMain {
                self.noImagesLabel.isHidden = true
            }
            
            var numberOfImages = photoAlbum.count
            let placeHolder : UIImage = #imageLiteral(resourceName: "placeholder")
            let data = UIImagePNGRepresentation(placeHolder)! as NSData
            var arrayOfImagesToDownload =  [Image]()
            
            stack.performBackgroundBatchOperation({ (workerContext) in
                repeat
                {
                    let imageWithPlaceHolder = Image(data: data, context: stack.context)
                    imageWithPlaceHolder.pin = self.pinSelected!
                    arrayOfImagesToDownload.append(imageWithPlaceHolder)
                    numberOfImages -= 1
                }while numberOfImages > 0
                
                Image.downloadImages(from: photoAlbum, withPin: self.pinSelected!, to: arrayOfImagesToDownload)
                self.performUIUpdatesOnMain {
                    self.downloadButton.isUserInteractionEnabled = true
                    self.downloadButton.isEnabled = true
                }
            })
        }
    }
    
    //MARK:- helper methods
    
    func configureCollectionView() {
        
        let space: CGFloat = 3
        let width = (view.frame.size.width - (3 * space)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: 95)
        collectionView.allowsMultipleSelection = false
    }
    
    
    func configureMap() {
        mapView.isUserInteractionEnabled = false
        mapView.delegate = mapDelegate
        mapView.addAnnotation(pinSelected!.location!)
        let region = MKCoordinateRegionMake(pinSelected!.location!.coordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
    }
    
}
