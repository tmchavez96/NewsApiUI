//
//  ArticleViewModel.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/10/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


protocol articleContainer: class{
    func updateUI()
}

final class ArticleViewModel {
    static var shared = ArticleViewModel()
    private init() {
        getArticles()
    }
    //MARK: Variables
    weak var delegate: articleContainer?
    var queryVM = "Corona Virus"
    var sourceVM:String? = nil
    var sortVM:String? = nil
    var pageVM:Int = 1
    var totalResults = -1 {
        didSet {
            setMaxPage()
        }
    }
    var maxPage:Int? = nil
    var articleList:[Article] = [] {
        didSet{
            delegate?.updateUI()
        }
    }
    
    //MARK: FUunctions
    func getArticles(){
        clearArticles()
        guard let url = UrlService.getSearchUrl(query: queryVM, sources: sourceVM, sortBy: sortVM, page: pageVM) else { return }
        HttpHandler.shared.getArticles(url) { [weak self] result in
            guard let resultDec = result else {return}
            self?.totalResults = resultDec.totalResults
            self?.articleList = resultDec.articles
        }
    }
    
    
    func getNextArticle(title articleTitle:String)->Article?{
        var foundFlag = false
        for art in articleList{
            if(foundFlag){
                return art
            }
            if(art.title == articleTitle){
                foundFlag = true;
            }
        }
        return nil
    }
    
    
    func getPrevArticle(title articleTitle:String)->Article?{
        var prevArt:Article? = nil
        for art in articleList{
            if(art.title == articleTitle){
                return prevArt
            }
            prevArt = art
        }
        return nil
    }
    
    
    //MARK: Getters/Setters
    func clearArticles(){
        articleList = []
        ImageCache.shared.clearCahce()
    }
    
    func setQuery(_ searchQuery:String){
        queryVM = searchQuery
        pageVM = 1
        getArticles()
    }
      
    
    func setSource(_ newSource:String?){
        sourceVM = newSource
        pageVM = 1
        getArticles()
    }
    
    func setSort(_ newFilt:String?){
        sortVM = newFilt
        pageVM = 1
        getArticles()
    }
    
    func clearFilters(){
        sourceVM = nil
        sortVM = nil
        pageVM = 1
        getArticles()
    }
    
    func getNumberOfArticles() -> Int{
        return articleList.count
    }
    
    func getArticleFromIndex( _ index:Int) -> Article {
        return articleList[index]
    }
    
    func setMaxPage(){
        maxPage = Int(totalResults / 20)
        maxPage =  (maxPage! > 5 ? 5 : maxPage)
    }
    
    func getPageLabel() ->String{
        if totalResults == 0 {
            return "no results"
        }
        if let max = maxPage {
            return "Page \(pageVM) of \(max)"
        }else{
            return "Page \(pageVM)"
        }
    }
    
    func incrementPage(){
        guard let max = maxPage else { return }
        if( pageVM < max){
            pageVM += 1
        }
        print("going to page \(pageVM), max - \(max)")
        getArticles()
    }
    
    func decrementPage(){
        if (pageVM > 1){
            pageVM -= 1
        }
        print("going to page \(totalResults)")
        getArticles()
    }
    
}
