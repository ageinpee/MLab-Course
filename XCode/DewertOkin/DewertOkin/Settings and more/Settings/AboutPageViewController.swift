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
        
        self.teamlabel.text = "Our team contains the following members: \n - Danial Bagheri (Social Media Guy) \n - Henrik Peters \n - Jan Robert Janneck (Technical Lead) \n - Jawad Shah \n - Nima Rahrakhshan (Project Lead) \n - Peter Herner"
    }
}
