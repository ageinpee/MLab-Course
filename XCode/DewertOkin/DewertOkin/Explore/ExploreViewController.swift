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
    
    // Data from ExploreMapViewController
    var displayingVendor: Vendor!
    var displayingAnnotation: MKAnnotationView!
    var vendorAccessories = [Accessory]()
    
    // UI Elements
    lazy var backgroundAlphaView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .clear
        view.alpha = 0.0
        view.isUserInteractionEnabled = true
        return view
    }()
    let closeButton = UIButton(type: .custom)
    let vendorView = UIView()
    var currentState: State = .halfOpen
    var bottomConstraint = NSLayoutConstraint()
    
    var vendorName = UILabel()
    var vendorStreet = UILabel()
    var vendorOpeningHours = UILabel()
    var vendorTelephoneNumber = UILabel()
    
    var collectionView: UICollectionView!
    
    // Gesture Recognizer & Animation Elements
    var animationProgress = [CGFloat]()
    var runningAnimators = [UIViewPropertyAnimator]()
    var vendorViewOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Vendors"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.isUserInteractionEnabled = true
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        initializeMap(radiusInMeters: 2000.0)
        initializeVendors()
    }
        
    @IBAction func showAccessoriesList(_ sender: Any) {
        performSegue(withIdentifier: "ShowAccessoriesList", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        print("Oops, buy a better iPhone mate! #JustAppleThings")
    }
}
