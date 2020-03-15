//
//  Article.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/10/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable{
    var totalResults:Int
    var articles:[Article]
}

struct Article: Decodable {
    var source: Source
    var title: String
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}

struct Source: Decodable {
    var id:String?
    var name:String
}
