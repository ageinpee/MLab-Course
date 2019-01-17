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

class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var selectedVendor: Vendor?
    var selectedAnnotation: MKAnnotationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Vendors"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        mapView.delegate = self
        initializeMap(radiusInMeters: 2000.0)
        initializeVendors()
    }
        
    @IBAction func showAccessoriesList(_ sender: Any) {
        performSegue(withIdentifier: "ShowAccessoriesList", sender: self)
    }
}