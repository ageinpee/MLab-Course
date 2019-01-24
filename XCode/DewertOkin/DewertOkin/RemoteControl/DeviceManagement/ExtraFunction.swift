//
//  ExtraFunction.swift
//  DewertOkin
//
//  Created by Henrik Peters on 23.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation

class ExtraFunction{
    
    var type: ExtraFunctions = .NaN
    var title: String = String()
    var hex: Data = Data()
    
    init() {
        
    }
    
    init(asType: ExtraFunctions, withTitle: String, withHex: Data) {
        self.type = asType
        self.title = withTitle
        self.hex = withHex
    }
}
