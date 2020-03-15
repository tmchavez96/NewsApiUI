//
//  httpHandler.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/10/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

final class HttpHandler {
    static var shared = HttpHandler()
    private init(){}
    
    func getArticles(_ url:URL, completion: @escaping (ArticleResponse?) -> Void){
        URLSession.shared.dataTask(with: url){ (data,_,err) in
            if let error = err{
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let myData = data{
                do{
                    let httpResult = try JSONDecoder().decode(ArticleResponse.self, from: myData)
                    completion(httpResult)
                    return;
                }
                catch{
                    print(error.localizedDescription)
                }
            }
            completion(nil)
            return
        }.resume()
        
    }
    
    func getImage(_ urlStr:String, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url){ (data,_,err) in
            if let error = err {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let imgData = data {
                if let resImg = UIImage(data: imgData){
                    completion(resImg)
                    return
                }
            }
            completion(nil)
            return
        }.resume()
    }
    
}
