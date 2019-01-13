//
//  ExploreList.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class ExploreAccessoriesViewController: UIViewController, UITableViewDelegate {
    
    var accessoriesList = [Accessory]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Accessories"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func initializeAccessories() {
        let accessoryList = parseAccessories()
        guard accessoryList.count != 0 else { return }
        for number in 0..<(accessoryList.count - 1) {
            let accessorie = Accessory(imageName: accessoryList[number].imageName, name: accessoryList[number].name, accessoryDescription: accessoryList[number].accessoryDescription)
        }
    }
}
