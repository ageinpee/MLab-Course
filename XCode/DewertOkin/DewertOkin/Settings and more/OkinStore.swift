//
//  OkinStore.swift
//  DewertOkin
//
//  Created by Jan Robert on 11.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class OkinStore: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let phone: String
    let websiteURL: URL?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, phone: String, websiteURL: URL, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.phone = phone
        self.websiteURL = websiteURL
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
    //   return phone
        return locationName
    //    return websiteURL?.absoluteString
        
    }
    struct OkinStoreJSON: Decodable {
        
        let title: String?
        let locationName: String
        let phone: String
        let websiteURL: URL?
  //      let coordinate: CLLocationCoordinate2D
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
