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
    var selectedAccessories = [Accessory]()
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Accessories"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(filterVendors(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        initializeAccessories()
        //tableView.beginUpdates()
    }
    
    func initializeAccessories() {
        let accessoryList = parseAccessories()
        guard accessoryList.count != 0 else { return }
        for number in 0..<(accessoryList.count) {
            let accessory = Accessory(imageName: accessoryList[number].imageName, name: accessoryList[number].name, accessoryDescription: accessoryList[number].accessoryDescription)
            accessoriesList.append(accessory)
        }
        registerAccessories()
        tableView.reloadData()
    }
    
    func registerAccessories() {
        self.tableView.register(AccessoryCustomCell.self, forCellReuseIdentifier: "customAccessoryCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = (self.view.frame.height / 5)
    }
    
    @objc func filterVendors(_ sender: Any) {
        
    }
}

extension ExploreAccessoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customAccessoryCell") as! AccessoryCustomCell
        let image = UIImage(named: accessoriesList[indexPath.row].imageName)
        cell.accessoryImage = image
        cell.accessoryName = accessoriesList[indexPath.row].name
        cell.accessoryDescription = accessoriesList[indexPath.row].accessoryDescription
        
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height / 5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! AccessoryCustomCell
        cell.accessoryType = .checkmark
        if !(selectedAccessories.contains(accessoriesList[indexPath.row])){
                selectedAccessories.append(accessoriesList[indexPath.row])
            }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! AccessoryCustomCell
        cell.accessoryType = .none
        selectedAccessories = selectedAccessories.filter { $0.name != selectedAccessories[indexPath.row].name}
    }
}
