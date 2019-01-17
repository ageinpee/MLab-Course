//
//  Achievement.swift
//  DewertOkin
//
//  Created by Jan Robert on 01.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation

struct Achievement: Codable {
    // Establishes the basic Structure of achievements with the type of the variables
    var id: Int
    var title: String
    var description: String
    var image: String
    var type: AchievementType
    var progress: Float
}
