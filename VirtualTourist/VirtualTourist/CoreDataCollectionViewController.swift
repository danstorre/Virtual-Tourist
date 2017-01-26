//
//  CoreDataCollectionViewController.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/14/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit
import CoreData


class CoreDataCollectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
        }
    }
    
    // Do not worry about this initializer. I has to be implemented
    // because of the way Swift interfaces with an Objective C
    // protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

// MARK: - executeSearch CoreDataCollectionViewController
extension CoreDataCollectionViewController{
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}


// MARK: - CoreDataCollectionViewController (Collection Data Source)

extension CoreDataCollectionViewController : UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
    
}


// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

extension CoreDataCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch (type) {
        case .insert:
            collectionView?.insertSections(set)
        case .delete:
            collectionView?.deleteSections(set)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            collectionView?.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView?.deleteItems(at: [indexPath!])
        case .update:
            collectionView?.reloadItems(at: [indexPath!])
        case .move:
            collectionView?.deleteItems(at: [indexPath!])
            collectionView?.insertItems(at: [newIndexPath!])
        }
    }
    
}
