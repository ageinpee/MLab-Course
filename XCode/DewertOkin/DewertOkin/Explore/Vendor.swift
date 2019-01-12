//
//  Vendor.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 11.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import MapKit

class Vendor: NSObject, MKAnnotation {
    
    let name: String
    let street: String
    let openingHour: Int
    let closingHour: Int
    let telephoneNumber: String
    // let accessories : [Accessory]
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return street
    }
    
    init(name: String, street: String, openingHour: Int, closingHour: Int, telephoneNumber: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.street = street
        self.openingHour = openingHour
        self.closingHour = closingHour
        self.telephoneNumber = telephoneNumber
        self.coordinate = coordinate
        
        super.init()
    }
    
    
}
