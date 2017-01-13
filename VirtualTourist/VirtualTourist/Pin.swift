//
//  Pin.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/13/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit

struct Pin {

    let album : [Image]?
    let location : Location
    
    init(album: [Image], location: Location){
        
        self.album = album
        self.location = location
    }
    
    init() {
        self.album = [Image]()
        self.location = Location()
    }
}
