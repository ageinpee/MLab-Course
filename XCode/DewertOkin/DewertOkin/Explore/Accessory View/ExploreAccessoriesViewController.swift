//
//  ExploreList.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    
    private let extraFuncDict = ["Massage Back" : ExtraFunctions.massage_back,
                                 "Massage Neck" : ExtraFunctions.massage_neck,
                                 "Massage Legs" : ExtraFunctions.massage_legs,
                                 "Under Bed Lighting" : ExtraFunctions.ubl,
                                 //Extrafunctions from Explore
                                 "Satellite Speaker": ExtraFunctions.satellite_speaker,
                                 "Subwoofer Speaker": ExtraFunctions.subwoofer_speaker,
                                 "Massage Motor" : ExtraFunctions.massage_motor,
                                 "Under_Bed_Lighting" : ExtraFunctions.under_bed_lighting,
                                 "Light Strip" : ExtraFunctions.light_strip,
                                 "Seat Heating" : ExtraFunctions.seat_heating,
                                 "Hands Free Kit" : ExtraFunctions.hands_free_kit,
                                 "RGB Lighting Strip" : ExtraFunctions.rgb_lighting_strip,
                                 "RGB Lighting Control Unit" : ExtraFunctions.rgb_lighting_control_unit,
                                 //Default Handler
                                 "NaN" : ExtraFunctions.NaN]
    
    func saveDevice(withUUID: String, named: String, forHandheldID: String, withStyle: String, withExtraFucntions: String) {
        let device = Devices(context: PersistenceService.context)
        device.uuid = withUUID
        device.name = named
        device.handheld = forHandheldID
        device.style = withStyle
        device.extraFunctions = withExtraFucntions
        PersistenceService.saveContext()
    }
    
    func updateDevicesFunctions(newExtraFunctions: String, uuid: String) {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            for device in savedDevices {
                if device.uuid == uuid {
                    device.extraFunctions = newExtraFunctions
                    try PersistenceService.context.save()
                }
            }
        } catch {
            print("Devices couldn't be loaded")
        }
    }
    
    @objc func buyingAccessory(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: cell) {
                tableView.cellForRow(at: indexPath)?.isHighlighted = false
                globalDeviceObject.availableExtraFunctions.append(extraFuncDict[accessoriesList[indexPath.row].name] ?? .NaN)
                self.updateDevicesFunctions(newExtraFunctions: DeviceObject.convertExtraFunctionsToString(functions: globalDeviceObject.availableExtraFunctions),
                                            uuid: globalDeviceObject.uuid)
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
