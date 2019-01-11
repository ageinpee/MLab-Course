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
}

struct AccessorieData: Decodable {
    let image: String
    let name: String
    let accessorieDescription: String
}
