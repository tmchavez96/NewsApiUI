//
//  SearchViewController.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/9/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var articleTable: UITableView!
    var articleVM = ArticleViewModel.shared
    var query:String = ""
    
    
    //page outlets
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var Previous: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        articleVM.delegate = self
        //articleTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        articleTable.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        articleTable.rowHeight = 100;
        self.view.backgroundColor = UIColor(named: "BackGroundColor")
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
        navigationItem.searchController?.searchBar.delegate = self as UISearchBarDelegate
        stylePageElms()
    }
    
    func stylePageElms(){
        pageLabel.text = articleVM.getPageLabel()
        Previous.setTitle("Prev", for: .normal)
        Previous.setTitleColor(UIColor(named: "nextPrev"), for: .normal)
        Previous.layer.cornerRadius = 5
        
        nextPage.setTitle("Next", for: .normal)
        nextPage.setTitleColor(UIColor(named: "nextPrev"), for: .normal)
        nextPage.layer.cornerRadius = 5
        
    }
    
    @IBAction func gotoPrevious(_ sender: Any) {
        articleVM.decrementPage()
        pageLabel.text = articleVM.getPageLabel()
    }
    @IBAction func gotoNext(_ sender: Any) {
        articleVM.incrementPage()
        pageLabel.text = articleVM.getPageLabel()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        articleVM.clearArticles()
        guard let searchQuery = searchBar.text else {return}
        query = searchQuery
        articleVM.setQuery(query)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleVM.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curArticle = articleVM.articleList[indexPath.row]
        let cell = articleTable.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        cell.articleThumbNail.image = nil
        if let imgUrl = curArticle.urlToImage {
            if let cachedImg = ImageCache.shared.getImage(curArticle.title){
                DispatchQueue.main.async {
                    cell.articleThumbNail.image = cachedImg
                }
            }else{
                HttpHandler.shared.getImage(imgUrl, completion: { (resImg) in
                    DispatchQueue.main.async {
                        if let cellImg = resImg {
                            ImageCache.shared.addImage(curArticle.title, cellImg)
                            cell.articleThumbNail.image = cellImg
                        }
                    }
                })
            }
        }
        
        cell.articleTitle.text = curArticle.title
        
        cell.articleSource.text = curArticle.source.name
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailVC.articleVM = articleVM
        detailVC.curArticle = articleVM.getArticleFromIndex(indexPath.row)
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(detailVC, animated: true) //push onto the stack
        
    }
}

extension SearchViewController: articleContainer {
    func updateUI() {
        DispatchQueue.main.async {
            self.articleTable.reloadData()
            self.pageLabel.text = self.articleVM.getPageLabel()
        }
    }
}
