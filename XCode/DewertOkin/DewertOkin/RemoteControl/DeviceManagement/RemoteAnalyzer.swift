//
//  RemoteAnalyzer.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 04.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation

class RemoteAnalyzer {
    
    var csvData: [[String]] = [[String]]()  //NOTE: Maybe first column has to be thrown away
                                            //ANOTHER NOTE: our Remote has no. 82418
    var csvLegend: [String] = [String]()
    
    init() {
        csvLegend = initCSVLegend()
    }
    
    init(with data: [[String]]) {
        csvLegend = initCSVLegend()
        csvData = data
    }
    
    private func initCSVLegend() -> [String] {
    return ["article_number", "description", "type",
    "M1_up", "M1_down",
    "M2_up", "M2_down",
    "M3_up", "M3_down",
    "M4_up", "M4_down",
    "M5_up", "M5_down",
    "Reset_up", "Reset_down",
    "Mem1", "Mem2", "Mem3", "Mem4", "Mem_save",
    "Synch",
    "Socket",
    "UBL",
    "child_save", "Torch",
    "Massage1", "Massage2", "Massage3", "Massage_off", "Massage_display"]
    }
    
    func getData(byArticleNumber artNr: String) -> [String]{
        for remote in csvData {
            if remote[0] == artNr {
                return remote
            }
        }
        return [""]
    }
    
    func getData(byDescription description: String) -> [String] {
        for remote in csvData {
            if remote[1] == description {
                return remote
            }
        }
        return [""]
    }
}

enum Functions {
    case article_number
    case description
    case type
    case M1_up
    case M1_down
    case M2_up
    case M2_down
    case M3_up
    case M3_down
    case M4_up
    case M4_down
    case M5_up
    case M5_down
    case Reset_up
    case Reset_down
    case Mem1
    case Mem2
    case Mem3
    case Mem4
    case Mem_save
    case Synch
    case Socket
    case UBL
    case child_save
    case Torch
    case Massage1
    case Massage2
    case Massage3
    case Massage_off
    case Massage_display
}
