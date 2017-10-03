//
//  Photo.swift
//  Photorama
//
//  Created by Shehab Saqib on 07/06/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import UIKit

class Photo {
    
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
   
}

extension Photo: Equatable{}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoID == rhs.photoID
}
