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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let savedDevics = try PersistenceService.context.fetch(fetchRequest)
            self.cellDevicesData = []
            self.devicesList = savedDevics
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return cell
    }
    
    
}

struct DevicesData {
    let image: UIImage?
    let name: String?
    let status: String?
}
