//
//  DevicesListTableViewExtension.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 07.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreData
import UIKit

extension DevicesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDevicesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customDevicesCell") as! DevicesListCustomCell
        cell.deviceImage = cellDevicesData[indexPath.row].image
        cell.deviceName = cellDevicesData[indexPath.row].name
        cell.deviceStatus = cellDevicesData[indexPath.row].status
        cell.accessoryType = .disclosureIndicator
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        let connect = connectAction(at: indexPath)
        let swipeGesture = UISwipeActionsConfiguration(actions: [connect,edit,delete])
        swipeGesture.performsFirstActionWithFullSwipe = false
        return swipeGesture
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completion) in
            
            do {
                let deviceToDelete = self.devicesList[indexPath.row]
                let savedDevices = try PersistenceService.context.fetch(fetchRequest)
                for device in savedDevices {
                    if deviceToDelete.uuid == device.uuid {
                        if (deviceToDelete.uuid == globalDeviceObject.uuid) {
                            globalDeviceObject = DeviceObject()
                            UserDefaults.standard.set("nil", forKey: "lastConnectedDevice_uuid")
                        }
                        PersistenceService.context.delete(device)
                        try PersistenceService.context.save()
                    }
                }
                self.fetchDevices()
            } catch {
                print("Devices couldn't be load")
            }
        }
        
        action.backgroundColor = .red
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Edit") {
            (action, view, completion) in
            
            let alert = UIAlertController(title: "Name of furniture?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Name"
                textField.text = self.devicesList[indexPath.row].name
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let newName = alert.textFields?.first?.text
                self.updateDevicesName(newName: newName!, uuid: self.devicesList[indexPath.row].uuid!)
            }))
            self.present(alert, animated: true)
        }
        action.backgroundColor = .orange
        return action
    }
    
    func connectAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Connect") {
            (action, view, completion) in
            
            self.deviceObjectToConnect = self.devicesList[indexPath.row]
            self.performSegue(withIdentifier: "ConnectToDevice", sender: self)
        }
        
        action.backgroundColor = .blue
        return action
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.deviceObjectToConnect = self.devicesList[indexPath.row]
        
        self.performSegue(withIdentifier: "ConnectToDevice", sender: self)
    }
    
}
