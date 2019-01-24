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
    var selectedAccessories = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Accessories"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(filterVendors(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let holdToBuyGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(buyingAccessory(_:)))
        holdToBuyGestureRecognizer.minimumPressDuration = 1.0
        tableView.addGestureRecognizer(holdToBuyGestureRecognizer)
        initializeAccessories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedAccessories = defaults.stringArray(forKey: "FilterAccessories") ?? []
        tableView.reloadData()
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
        self.tableView.estimatedRowHeight = (self.view.frame.height / 6)
    }
    
    @objc func filterVendors(_ sender: Any) {
        defaults.set(selectedAccessories, forKey: "FilterAccessories")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func buyingAccessory(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: cell) {
                print("HAHA")
            }
        }
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
        if (selectedAccessories.contains(cell.accessoryName!)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height / 6)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! AccessoryCustomCell
        if !(selectedAccessories.contains(accessoriesList[indexPath.row].name)){
            selectedAccessories.append(accessoriesList[indexPath.row].name)
            cell.accessoryType = .checkmark
            cell.isSelected = true
        } else if (selectedAccessories.contains(accessoriesList[indexPath.row].name)) {
            cell.accessoryType = .none
            cell.isSelected = false
            selectedAccessories = selectedAccessories.filter { $0 != cell.accessoryName}
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}
