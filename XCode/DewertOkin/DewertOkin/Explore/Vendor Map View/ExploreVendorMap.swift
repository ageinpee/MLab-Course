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
        var tempVendor = [Vendor]()
        for number in 0..<(vendorList.count) {
            let vendor = Vendor(name: vendorList[number].name, street: vendorList[number].street, openingHour: vendorList[number].openingHour, closingHour: vendorList[number].closingHour, telephoneNumber: vendorList[number].telephoneNumber, accessories: (convertAccessoryData(accessories: vendorList[number].accessories)), latitude: vendorList[number].latitude, longitude: vendorList[number].longitude)
            tempVendor.append(vendor)
        }
        filteredVendors = tempVendor
    }
    
    func convertAccessoryData(accessories: [AccessoryData]) -> [Accessory] {
        var accessorieList = [Accessory]()
        for number in 0..<(accessories.count) {
            let accessory = Accessory(imageName: accessories[number].imageName, name: accessories[number].name, accessoryDescription: accessories[number].accessoryDescription)
            accessorieList.append(accessory)
        }
        return accessorieList
    }
    
    func displayDetailView() {
        vendorViewOffset = self.view.frame.height / 4
        
        initializeVendorView()
        initializeVendorInformation()
        initializeAccessoryCollection()
        initializeVendorWebsite()
    }
    
    func closeDetailView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            self.bottomConstraint.constant = self.vendorViewOffset * 2
            self.backgroundAlphaView.backgroundColor = .clear
            self.backgroundAlphaView.alpha = 0.0
        })
        transitionAnimator.addCompletion{_ in
            self.backgroundAlphaView.removeFromSuperview()
            self.vendorWebsite.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.vendorName.removeFromSuperview()
            self.vendorStreet.removeFromSuperview()
            self.collectionViewName.removeFromSuperview()
            self.collectionView.removeFromSuperview()
            self.vendorView.removeFromSuperview()
            self.mapView.deselectAnnotation(self.displayingAnnotation.annotation, animated: true)
            self.runningAnimators.removeAll()
        }
        transitionAnimator.isUserInteractionEnabled = true
        transitionAnimator.startAnimation()
    }
    
}

extension ExploreViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Vendor else { return nil }
        let identifier = "identifier"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.isUserInteractionEnabled = true
            
            view.markerTintColor = .red
            view.glyphTintColor = .red
            view.glyphText = ""
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view != mapView.userLocation else { return }
        let location = view.annotation as! Vendor
        displayingVendor = location
        displayingAnnotation = view
        displayDetailView()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        closeDetailView()
    }
}
