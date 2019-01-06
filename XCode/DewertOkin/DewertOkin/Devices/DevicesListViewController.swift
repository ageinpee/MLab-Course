//
//  DevicesListViewController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 03.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreData
import UIKit

class DevicesListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var devicesList = [Devices]()
    var cellDevicesData = [DevicesData]()
    var deviceToConnect: CBPeripheral?
    var remoteControl = RemoteController()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Devices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchDevices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDevices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDevices()
    }
    
    func fetchDevices() {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            self.cellDevicesData = []
            self.devicesList = savedDevices
            for devices in devicesList {
                cellDevicesData.append(DevicesData.init(image: UIImage(named: "chair_pictogram"), name: devices.name, status: "Connected"))
            }
            self.registerDevices()
            self.tableView.reloadData()
        } catch {
            print("Couldn't update the Devices, reload!")
        }
    }
    
    func registerDevices() {
        self.tableView.register(DevicesListCustomCell.self, forCellReuseIdentifier: "customDevicesCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BluetoothPairingConnectViewController {
            destination.selectedPeripheral = self.deviceToConnect
        }
    }
}

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
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        let connect = connectAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit,connect])
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
                        PersistenceService.context.delete(device)
                        try PersistenceService.context.save()
                    }
                }
                self.fetchDevices()
            } catch {
                print("Devices couldn't be load")
            }
            
        }
        //action.image =
        action.backgroundColor = .yellow
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
    }
    
    func connectAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completion) in
            
            let device = self.devicesList[indexPath.row]
            guard self.bluetoothFlow.isInRange(uuid: device.uuid) else { return }
            guard let deviceToBeConnected = self.bluetoothFlow.getPeripheralWithUUID(uuid: device.uuid) else { return }
            self.deviceToConnect = deviceToBeConnected
            self.performSegue(withIdentifier: "PairingConnection", sender: self)
                
        }
        //action.image =
        action.backgroundColor = .blue
        return action
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

struct DevicesData {
    let image: UIImage?
    let name: String?
    let status: String?
}
