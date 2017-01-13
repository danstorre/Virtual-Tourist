//
//  Album.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/13/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit

struct Image {

    
    var dataImage: Data?
    
    init(dataImage: Data){
        
        self.dataImage = dataImage
    }
    
    init() {
        self.dataImage = Data()
    }
    
    init(dictionary: [String:AnyObject]){
    

        /* GUARD: Does our photo have a key for 'url_m'? */
        guard let imageUrlString = dictionary[ConstatsFlickrAPI.FlickrResponseKeys.MediumURL] as? String else {
            return
        }
        
        // if an image exists at the url, set the image and title
        let imageURL = URL(string: imageUrlString)
        guard let imageData = try? Data(contentsOf: imageURL!) else{
            return
        }
        dataImage = imageData
        
    }
    
}

    //MARK:- Helper methods

extension Image{

    static func arrayOfImages(from dictionary: [[String:AnyObject]]) -> [Image]{
        var imagesToReturn = [Image]()
        
        for imageDic in dictionary{
            imagesToReturn.append(Image(dictionary: imageDic))
        }
        
        return imagesToReturn
        
    }
}
