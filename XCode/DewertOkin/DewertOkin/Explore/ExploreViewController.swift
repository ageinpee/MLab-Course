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

class ExploreViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var filteredVendors = [Vendor?]()
    var filteredAccessories = [Accessory?]()
    let defaults = UserDefaults.standard
    
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
    var vendorWebsite = UIButton()
    var collectionViewName = UILabel()
    
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
        
        for vendor in filteredVendors {
            mapView.addAnnotation(vendor!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let filter = defaults.stringArray(forKey: "FilterAccessories")
        guard !(filter?.isEmpty ?? true) else { return }
        initializeAccessories(name: filter!)
        let allAnnotations = mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        for vendorNumber in 0..<(filteredVendors.count) {
            let temp = filteredVendors[vendorNumber]!.accessories.filter { filteredAccessories.contains($0) }
            if (temp.count > 0){
                mapView.addAnnotation(filteredVendors[vendorNumber]!)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // I think I need to reset all accessories, who knows men
    }
        
    @IBAction func showAccessoriesList(_ sender: Any) {
        performSegue(withIdentifier: "ShowAccessoriesList", sender: self)
    }
    
    func initializeAccessories(name: [String]) {
        let accessoryList = parseAccessories()
        guard accessoryList.count != 0 else { return }
        var tempAcc = [Accessory]()
        for number in 0..<(accessoryList.count) {
            if (name.contains(accessoryList[number].name)){
                let accessory = Accessory(imageName: accessoryList[number].imageName, name: accessoryList[number].name, accessoryDescription: accessoryList[number].accessoryDescription)
                tempAcc.append(accessory)
            }
        }
        filteredAccessories = tempAcc
    }
    
    override func didReceiveMemoryWarning() {
        print("Oops, buy a better iPhone mate! #JustAppleThings")
    }
}
