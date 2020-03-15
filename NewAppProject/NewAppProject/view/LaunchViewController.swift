//
//  ViewController.swift
//  NewAppProject
//
//  Created by Taylor Chavez on 3/9/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        self.view.backgroundColor = UIColor.systemPink
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Welcome to News Demo"
        self.view.addSubview(label)
    }


}

