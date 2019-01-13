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
        let vendorList = parseVendor()
        guard vendorList.count != 0 else { return }
        for number in 0..<(vendorList.count - 1) {
            let vendor = Vendor(name: vendorList[number].name, street: vendorList[number].street, openingHour: vendorList[number].openingHour, closingHour: vendorList[number].closingHour, telephoneNumber: vendorList[number].telephoneNumber, latitude: vendorList[number].latitude, longitude: vendorList[number].longitude)
            mapView.addAnnotation(vendor)
        }
    }
    
    func initializeAccessories() {
        let accessoryList = parseAccessories()
        guard accessoryList.count != 0 else { return }
        for number in 0..<(accessoryList.count - 1) {
            let accessorie = Accessory(imageName: accessoryList[number].imageName, name: accessoryList[number].name, accessoryDescription: accessoryList[number].accessoryDescription)
        }
    }
    
}
