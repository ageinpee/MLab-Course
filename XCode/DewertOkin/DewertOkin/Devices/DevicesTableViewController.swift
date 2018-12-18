//
//  DevicesTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 18.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class DevicesTableViewController: UITableViewController {
    
    var deviceList: [Device] = [
        Device(name: "Cozy Chair",
               description: "HE150",
               commandService: CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B"),
               keycodeUUID: CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B"),
               feedbackUUID: CBUUID(string: "62741625-52F9-8864-B1AB-3B3A8D65950B")
        ),
        Device(name: "Office Table",
               description: "HE150",
               commandService: CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B"),
               keycodeUUID: CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B"),
               feedbackUUID: CBUUID(string: "62741625-52F9-8864-B1AB-3B3A8D65950B")
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPairingWindow)), animated: true)
        
        tableView.register(DevicesTableViewCell.self, forCellReuseIdentifier: "DeviceCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Devices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return deviceList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DevicesTableViewCell {
            
            cell.textLabel?.text = deviceList[indexPath.row].name
            cell.detailTextLabel?.text = deviceList[indexPath.row].description
            
            return cell
        }

        // Configure the cell...

        return DevicesTableViewCell()
    }
    
    @objc private func showPairingWindow() {
        
    // Can not be executed due to a bug in the pairing controller
        
//        if let vc = UIStoryboard(name: "BluetoothPairing", bundle: nil).instantiateInitialViewController() as? BluetoothPairingViewController {
//            self.present(vc, animated: true) {
//                print("Starting Pairing Process")
//            }
//        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


}

class DevicesTableViewCell: UITableViewCell {
    
    // Actually check if the specific device is connected!
    var deviceIsConnected = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        let statusLabel = UILabel(frame: CGRect(x: bounds.midX, y: bounds.midY, width: 110.0, height: 16.0))
        statusLabel.text = deviceIsConnected ? "Connected" : "Switch"
        statusLabel.textAlignment = .right
        statusLabel.textColor = deviceIsConnected ? .green : .red
        
        accessoryView = statusLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

struct Device {
    var name: String
    var description: String
    var commandService: CBUUID
    var keycodeUUID: CBUUID
    var feedbackUUID: CBUUID
}
