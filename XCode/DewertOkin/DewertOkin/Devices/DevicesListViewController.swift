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
    @IBOutlet weak var header: UINavigationBar!
    
    var devicesList = [Devices]()
    var cellDevicesData = [DevicesData]()
    var deviceToConnect: CBPeripheral?
    var deviceObjectToConnect: Devices?
    var remoteControl = RemoteController()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Devices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
        header.topItem?.title = "Your Devices"
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            remoteControl.layoutRemote()
        }
    }
    
    func fetchDevices() {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            self.cellDevicesData = []
            self.devicesList = savedDevices
            var deviceObject = DeviceObject()
            for devices in devicesList {
                deviceObject = DeviceObject(withUUID: devices.uuid ?? UUID().uuidString,
                                            named: devices.name ?? "unknown device",
                                            withHandheldID: devices.handheld ?? "82418" ,
                                            withStyle: devices.style ?? "filled",
                                            withExtraFunctions: DeviceObject.convertStringToExtraFunctions(withString: devices.extraFunctions ?? "")
                )
                cellDevicesData.append(DevicesData.init(image: deviceObject.deviceImages[1],
                                                        name: devices.name,
                                                        status: deviceStatus(device: devices)))
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Couldn't connect to furniture",message: "It seems like the furniture is out of range", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func updateDevicesName(newName: String, uuid: String) {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            for device in savedDevices {
                if device.uuid == uuid {
                    device.name = newName
                    try PersistenceService.context.save()
                    globalDeviceObject = DeviceObject(withUUID: device.uuid ?? "ERROR - no entry found",
                                                      named: device.name ?? "ERROR - no entry found",
                                                      withHandheldID: device.handheld ?? "NaN",
                                                      withStyle: device.style ?? "filled",
                                                      withExtraFunctions: DeviceObject.convertStringToExtraFunctions(withString: device.extraFunctions ?? ""))
                    UserDefaults.standard.set(globalDeviceObject.uuid, forKey: "lastConnectedDevice_uuid")
                }
            }
            self.fetchDevices()
        } catch {
            print("Devices couldn't be load")
        }
    }
    
    func deviceStatus(device: Devices) -> String {
        if (bluetooth.connectedPeripheral?.identifier.uuidString == device.uuid) {
            return "Connected"
        }
        return ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BluetoothPairingConnectViewController {
            destination.selectedPeripheral = self.deviceToConnect
            destination.selectedDeviceObject = self.deviceObjectToConnect
        }
    }
    @IBAction func unwindToRemoteViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        if let mainVC = UIApplication.shared.keyWindow?.rootViewController as? MainViewController {
            if let remoteVC = mainVC.viewControllers?[0] as? RemoteController {
                remoteVC.viewDidLoad()
            }
        }
    }
}

struct DevicesData {
    let image: UIImage?
    let name: String?
    let status: String?
}
