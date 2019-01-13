//
//  ExploreMap.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import MapKit

extension ExploreViewController: DetailVendorViewControllerDelegate {
    
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
            view.canShowCallout = true
            view.isUserInteractionEnabled = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            view.markerTintColor = .blue
            view.glyphTintColor = .blue
            view.glyphText = ""
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Vendor
        self.selectedVendor = location
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        addBlurredBackground()
        performSegue(withIdentifier: "ShowVendorDetail", sender: self)
    }
    
    func addBlurredBackground() {
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        
        self.view.addSubview(blurredBackgroundView)
        self.navigationController!.view.addSubview(blurredBackgroundView)
        self.tabBarController!.view.addSubview(blurredBackgroundView)
    }
    
    func removeBlurredBackground() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffect.self) {
                subview.removeFromSuperview()
            }
        }
        for subview in navigationController!.view.subviews {
            if subview.isKind(of: UIVisualEffect.self) {
                subview.removeFromSuperview()
            }
        }
        for subview in tabBarController!.view.subviews {
            if subview.isKind(of: UIVisualEffect.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVendorViewController {
            destination.displayingVendor = self.selectedVendor
            destination.modalPresentationStyle = .overFullScreen
            destination.delegate = self
        }
    }
}
