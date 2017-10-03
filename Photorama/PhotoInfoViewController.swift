//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Shehab Saqib on 09/06/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo) {
            (result) -> Void in
            
            switch result {
            case let .success(image):
                    OperationQueue.main.addOperation() {
                        self.imageView.image = image
                }
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
          
        
        }
    }
    }

