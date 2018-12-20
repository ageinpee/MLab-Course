//
//  NearestVendorViewController.swift
//  DewertOkin
//I
//  Created by Jan Robert on 11.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import MapKit

class NearestVendorViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 53.538287, longitude: 9.978791)
       
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        
        let store1 = OkinStore(title: "Best Beds", locationName: "Holzweg 007", coordinate: CLLocationCoordinate2D(latitude: 53.58, longitude: 10.05))
        let store2 = OkinStore(title: "Chilly Chairs", locationName: "Köhlfleetdamm 9", coordinate: CLLocationCoordinate2D(latitude: 53.53, longitude: 9.9))
        let store3 = OkinStore(title: "Top Tables", locationName: "Grindelallee 123", coordinate: CLLocationCoordinate2D(latitude: 53.48, longitude: 9.95))
        mapView.addAnnotation(store1)
        mapView.addAnnotation(store2)
        mapView.addAnnotation(store3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Vendors close to you"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    let regionRadius: CLLocationDistance = 20000
   
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

}

extension NearestVendorViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? OkinStore else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! OkinStore
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
