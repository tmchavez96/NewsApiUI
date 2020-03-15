//
//  FilterCell.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/10/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    
    @IBOutlet weak var filterText: UITextField!
    var filtSelected: Bool = false
    var articleVM:ArticleViewModel!
    
//    @IBAction func informVMOfSource(_ sender: Any) {
//        articleVM.setSource(filterText.text)
//    }
    
    
    @IBAction func sendSource(_ sender: Any) {
        articleVM.setSource(filterText.text)
    }
    
}
