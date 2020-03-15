//
//  FilterViewController.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/10/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var filterList = ["Popular","Date","Source","X"]
    @IBOutlet weak var filterCollection: UICollectionView!
    
    var articleVM = ArticleViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }

    
    func setup(){
        view.backgroundColor = UIColor(named: "BackGroundOffset")
    }

}


extension FilterViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.articleVM = articleVM
        cell.filterText.text = filterList[indexPath.row]
        cell.backgroundColor = UIColor(named: "BackGroundColor")
        cell.filterText.backgroundColor = UIColor(named: "BackGroundColor")
        cell.filterText.borderStyle = .none
        cell.filterText.isEnabled = false
        if(cell.filterText.text == "Source"){
            cell.filterText.text = nil
            cell.filterText.isEnabled = true
            cell.filterText.placeholder = "Source"
        }
        cell.layer.cornerRadius = 15
        if(indexPath.row == (filterList.count - 1)){
            cell.backgroundColor = UIColor.red
            cell.filterText.backgroundColor = UIColor.red
            cell.layer.cornerRadius = 15
        }
        return cell
    }
    
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected filter")
        let cell = filterCollection.cellForItem(at: indexPath) as! FilterCell
        let filterMessage = cell.filterText.text
        var resetKey:String? = nil
        if(filterMessage != "X"){
            if(filterMessage == nil){
                return
            }
            cell.filtSelected = !cell.filtSelected
            let nextColor = (cell.filtSelected ? UIColor(named: "filterSelected") : UIColor(named: "BackGroundColor"))
            cell.backgroundColor = nextColor
            cell.filterText.backgroundColor = nextColor
            if(filterMessage == "Popular"){
                let message = (cell.filtSelected ? "popularity" : nil)
                articleVM.setSort(message)
                resetKey = "Date"
            }else if(filterMessage == "Date"){
                let message = (cell.filtSelected ? "publishedAt" : nil)
                articleVM.setSort(message)
                resetKey = "Popular"
            }
        }else{
            articleVM.clearFilters()
            resetKey = "All"
        }
        if let rKey = resetKey{
            for cell in filterCollection.visibleCells as! [FilterCell] {
                if cell.filterText.text == "X" { break }
                if rKey == "All"{
                    let nextColor = UIColor(named: "BackGroundColor")
                    cell.filtSelected = false
                    cell.backgroundColor = nextColor
                    cell.filterText.backgroundColor = nextColor
                    if(cell.filterText.placeholder == "Source"){
                        cell.filterText.text = nil
                    }
                }else if(rKey == cell.filterText.text){
                    let nextColor = UIColor(named: "BackGroundColor")
                    cell.filtSelected = false
                    cell.backgroundColor = nextColor
                    cell.filterText.backgroundColor = nextColor
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == (filterList.count - 1)){
            return CGSize(width: 40 , height: (view.frame.height - 20))
        }else{
            return CGSize(width: view.frame.width/3 , height: (view.frame.height - 20))
        }
    }
}
