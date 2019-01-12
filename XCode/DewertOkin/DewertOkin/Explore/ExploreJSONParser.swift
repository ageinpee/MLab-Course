//
//  ExploreJSONParser.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 11.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation

struct VendorData: Decodable {
    let name: String
    let street: String
    let openingHour: Int
    let closingHour: Int
    let telephoneNumber: String
    let longitude: Double
    let latitude: Double
}

struct AccessorieData: Decodable {
    let image: String
    let name: String
    let accessorieDescription: String
}
func parseVendor() -> [VendorData] {
    
    do {
        let jsonString = Bundle.main.path(forResource: "VendorList", ofType: "json")
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonString!), options: .alwaysMapped)
        let decoder = JSONDecoder()
        let vendorData = try decoder.decode([VendorData].self, from: jsonData)
        return vendorData
    } catch _ { }
    
    return []
}
