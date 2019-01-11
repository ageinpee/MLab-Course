//
//  ExploreViewController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExploreViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Devices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
