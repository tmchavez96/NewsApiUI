//
//  ImageCache.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/11/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

final class ImageCache{
    static var shared = ImageCache()
    private var cache:[String:UIImage] = [:]
    private init(){}
    
    func clearCahce(){
        cache = [:]
    }
    
    
    //send the url here as string
    func addImage(_ key:String, _ value:UIImage){
        cache[key] = value
    }
    
    
    func getImage(_ key:String) -> UIImage?{
        if let resImg = cache[key]{
            return resImg
        }else{
            return nil
        }
    }
}
