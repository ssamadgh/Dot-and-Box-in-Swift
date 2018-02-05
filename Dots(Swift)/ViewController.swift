//
//  ViewController.swift
//  Dots(Swift)
//
//  Created by Seyed Samad Gholamzadeh on 9/19/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.redColor()
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        self.view = DotsView(frame: UIScreen.main.bounds)
    }


}

