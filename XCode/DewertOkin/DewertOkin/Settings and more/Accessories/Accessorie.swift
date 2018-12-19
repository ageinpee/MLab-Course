//
//  Accessorie.swift
//  DewertOkin
//
//  Created by Jan Robert on 14.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation

class Accessorie {
    // The title of the accessorie
    let title: String
    // Should briefly describe the accessorie
    let description: String
    // The URL from which the image should be fetched
    let imageURL: URL?
    // Any further information, e.g. why is this product useful?
    //let otherText: String
    // The URL to be opened upon a click
    let targetURL: URL?
    
    init(title: String, description: String, imageURL: URL, targetURL: URL) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        //self.otherText = otherText
        self.targetURL = targetURL
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.imageURL = nil
        self.targetURL = nil
    }
    
    // json data example
    // let json =   "{ \"accessorie\":
    // [ { \"title\": \"LED-Leiste\",    \"description\": \"tolle LED leiste für jedermann!\",    \"imageURL\": \"http://www.dewertokin.com\", \"targetURL\": \"http://www,dewertokin.com\"  },
    // { \"firstName\": \"Angela\", \"lastName\": \"Merkel\", \"isAlive\": true },
    // { \"firstName\": \"George\", \"lastName\": \"Washington\", \"isAlive\": false } ] }"
    
    //
}
