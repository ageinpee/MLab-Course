//
//  AboutPageViewController.swift
//  DewertOkin
//
//  Created by Henrik Peters on 20.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class AboutPageViewController: UIViewController {
    
    @IBOutlet weak var teamlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About this app"
        
        self.teamlabel.text = "Our team contains the following members: \n Danial Bagheri \n Peter Herner \n Jan Robert Janneck \n Henrik Peters \n Nima Rahrakhshan \n Jawad Shah"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
