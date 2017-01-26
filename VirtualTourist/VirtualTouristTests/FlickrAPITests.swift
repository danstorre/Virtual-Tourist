//
//  VirtualTouristTests.swift
//  VirtualTouristTests
//
//  Created by Daniel Torres on 1/12/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import XCTest
import MapKit
@testable import VirtualTourist

class FlickrAPITests: XCTestCase {
    
    func test_GetPhotosFromFlickr_Photos() {
        
        let api = FlickrAPI()
        let expectationSuccess = expectation(description: "Success photo album Expectations")
        
        let stack = CoreDataStack(modelName: "VirtualTourist")!
        
        // Remove previous stuff (if any)
        do {
            try stack.dropAllData()
        } catch {
            print("Error droping all objects in DB")
        }
        
        let pin = Pin(context: stack.context)
        let location = Location(coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 50), pin: pin, context: stack.context)
        
        api.getPhotosFrom(pin: pin, savThemIn: stack.context) { (photoAlbum, error) in
        
            guard error == nil else {
                print(error!.description)
                return XCTFail(error!.description)
            }
            
            guard let photoAlbum = photoAlbum else {
                return XCTFail("there is no photo album recieved from Flickr")
            }
            
            XCTAssert(photoAlbum.count >= 0)
            
            expectationSuccess.fulfill()
        }
        
        
        waitForExpectations(timeout: 300, handler:nil)
        
    }
    
}
