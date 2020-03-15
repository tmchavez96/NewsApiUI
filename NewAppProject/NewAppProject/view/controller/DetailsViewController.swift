//
//  DetailsViewController.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/11/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var articleTitel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    
    
    @IBOutlet weak var articleContent: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    var isLoaded:Bool = false;
    
    var articleVM:ArticleViewModel!
    
    var curArticle:Article!{
        didSet{
            if(isLoaded){
                fillLabels()
                setImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        isLoaded = true;
        fillLabels()
        setImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isLoaded = false;
    }
    
    func setup(){
        articleContent.isEditable = false
        button.backgroundColor = UIColor(named:"BackGroundColor")
        button.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor(named: "BackGroundOffSet")
        //gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
               
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        let start = self.articleImage.frame
        let outWardCoordinateX = view.frame.width * 2
        if (sender.direction == .left) {
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.articleImage.frame = CGRect(x: outWardCoordinateX, y: start.minY, width:self.articleImage.frame.width, height: self.articleImage.frame.height)
            }) { result in
                guard let next = self.articleVM.getNextArticle(title: self.curArticle.title) else {return}
                self.curArticle = next
            }
                
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: { [weak self] in
                self?.articleImage.frame = start
            }, completion: nil)
            
            
        }
            
        if (sender.direction == .right) {
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.articleImage.frame = CGRect(x: (outWardCoordinateX * -1), y: start.minY, width:self.articleImage.frame.width, height: self.articleImage.frame.height)
            }) { result in
                guard let next = self.articleVM.getPrevArticle(title: self.curArticle.title) else {return}
                self.curArticle = next
            }
                
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: { [weak self] in
                self?.articleImage.frame = start
            }, completion: nil)

        }
    }
    
    func fillLabels(){
        articleTitel.text = curArticle.title
        articleSource.text = curArticle.source.name
        articleContent.text = curArticle.content
        //MARK: TODO - abstarct date formatting (maybe)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        var dateStr = ""
        if let date = dateFormatterGet.date(from: curArticle.publishedAt) {
            dateStr = dateFormatterPrint.string(from: date)
        }
        articleDate.text = dateStr
    }
    
    func setImage(){
        if let curImg = ImageCache.shared.getImage(curArticle.title){
            articleImage.image = curImg
        }
    }
    
    @IBAction func gotoFullArticle(_ sender: Any) {
        if let url = URL(string: curArticle.url){
            UIApplication.shared.open(url)
        }else{
            print("article didnt have a url")
        }
    }
    

}
