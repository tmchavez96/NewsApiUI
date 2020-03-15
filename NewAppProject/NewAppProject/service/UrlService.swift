//
//  UrlService.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/9/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


class UrlService {
    
    static var apiKey = "&apiKey=8848f2b810564451812cb79ddf53a5ca"
    static var base = "http://newsapi.org/v2/everything?q="
    static var sourceBase = "&sources="
    static var sortBase = "&sortBy="
    static var pageBase = "&page="
    
    
    static func encodeQuery(_ query:String) -> String{
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return encoded
    }
    
    static func getSearchUrl(query:String,sources:String?,sortBy:String?,page:Int) -> URL?{
        var urlString = base + encodeQuery(query) + apiKey
        urlString += (pageBase + String(page))
        if let source = sources{
            urlString += sourceBase + encodeQuery(source)
        }
        if let sort = sortBy{
            urlString += sortBase + encodeQuery(sort)
        }
        return URL(string: urlString)
    }
    
    
}
