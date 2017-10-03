//
//  PhotoStore.swift
//  Photorama
//
//  Created by Shehab Saqib on 07/06/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import Foundation
import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

class PhotoStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
   /* func fetchRecentPhotos(completion completion: (PhotoResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error) -> Void in
            
            /*if let jsonData = data {
                do {
                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                    print(jsonObject)
                }
                catch let error {
                    print("Error creating JSON object: \(error)")
                }
                }
            else if let requestError = error {
                print("Error fetching recent photos: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            } */
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result) 
            
        })
        task.resume()
    } */
    
    func fetchRecentPhotos(completion: @escaping (PhotoResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url as URL)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            let result = self.processRecentPhotosRequest(data: data, error: error as NSError?)
            completion(result)
        })
        task.resume()
    }
    
    func processRecentPhotosRequest(data: Data?, error: NSError?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photosFromJSONData(jsonData)
    }
    
    func fetchImageForPhoto(_ photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        if let image = photo.image {
            completion(.success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL as URL)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error as NSError?)
            
            if case let .success(image) = result {
                photo.image = image
            }
            
            completion(result)
        }) 
        task.resume()
    }

    
    
    func processImageRequest(data: Data?, error: NSError?) -> ImageResult {
        
        guard let
            imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }

}
