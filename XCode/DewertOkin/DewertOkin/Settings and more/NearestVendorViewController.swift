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
    private func checkForCompanyOfConnectedDevice() ->String{
        // integrate some sort of check here, to know which companies Device is connected right now.
        let company = "None"
            // Here should be listed the link to the "OkinStore"-JSON data of all companies
            switch company {
            case "Test":
                let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
                return jsonUrlString
            case "None":
                let jsonUrlString = "None"
                return jsonUrlString
            case "DewertOkin":
                let jsonUrlString = "https://dewertokin.com"
                return jsonUrlString
            default:
                let jsonUrlString = "https://dewertokin.com"
                return jsonUrlString
            }
    }

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 53.538287, longitude: 9.978791)
       
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        
//        let store1 = OkinStore(title: "Best Beds", locationName: "Holzweg 007", coordinate: CLLocationCoordinate2D(latitude: 53.58, longitude: 10.05))
//        let store2 = OkinStore(title: "Chilly Chairs", locationName: "Köhlfleetdamm 9", coordinate: CLLocationCoordinate2D(latitude: 53.53, longitude: 9.9))
//        let store3 = OkinStore(title: "Top Tables", locationName: "Grindelallee 123", coordinate: CLLocationCoordinate2D(latitude: 53.48, longitude: 9.95))
//        mapView.addAnnotation(store1)
//        mapView.addAnnotation(store2)
//        mapView.addAnnotation(store3)
        
        // --- json data web catch function for nearestVendor ---
        // first, it has to get the relevant company link , then it gets handled with the JSONDecoder and the data gets integrated into the OkinStore object
        let jsonUrlString = checkForCompanyOfConnectedDevice()
        
        if jsonUrlString != "None" {
            guard let url = URL(string: jsonUrlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                // now, here the data is handled
                guard let data = data else { return }
                
                do {
                    let OkinStoreJSON = try
                        JSONDecoder().decode([OkinStore.OkinStoreJSON].self, from: data)
                    print(OkinStoreJSON)
        
                }
                catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                }.resume()
        } else {
            let store1 = OkinStore(title: "Best Beds", locationName: "Holzweg 007", phone: "0190 55555", websiteURL: URL(string: "www.google.de")!, coordinate: CLLocationCoordinate2D(latitude: 53.58, longitude: 10.05))
            let store2 = OkinStore(title: "Chilly Chairs", locationName: "Köhlfleetdamm 9", phone: "0190 77777777", websiteURL: URL(string: "www.heise.de")!, coordinate: CLLocationCoordinate2D(latitude: 53.53, longitude: 9.9))
            let store3 = OkinStore(title: "Top Tables", locationName: "Grindelallee 123", phone: "0190 333", websiteURL: URL(string: "www.youtube.de")!, coordinate: CLLocationCoordinate2D(latitude: 53.48, longitude: 9.95))
            mapView.addAnnotation(store1)
            mapView.addAnnotation(store2)
            mapView.addAnnotation(store3)
        }
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
