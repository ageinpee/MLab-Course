//
//  ExploreMap.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import MapKit

extension ExploreViewController {
    
    func initializeMap(radiusInMeters: CLLocationDistance) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
            mapView.setRegion(viewRegion, animated: true)
            mapView.showsUserLocation = true
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func initializeVendors() {
        let vendors = parseVendor()
        let vendor = Vendor(name: vendors[0].name, street: vendors[0].street, openingHour: vendors[0].openingHour, closingHour: vendors[0].closingHour, telephoneNumber: vendors[0].telephoneNumber, latitude: vendors[0].latitude, longitude: vendors[0].longitude)
        mapView.addAnnotation(vendor)
    }
    
}
