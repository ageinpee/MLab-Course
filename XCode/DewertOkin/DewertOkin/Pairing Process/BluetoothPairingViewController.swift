//
//  BluetoothPairingViewController.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 10.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BluetoothPairingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectButton: UIButton!
    var availablePeripherals = [CBPeripheral]()
    var selectedPeripheral: CBPeripheral?
    var selectedCell: IndexPath?
    var search: Bool!
    
    var remoteControl = RemoteController()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        
        connectButton.layer.cornerRadius = 5
        search = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshPeripheralsList()
    }
    
    func refreshPeripheralsList() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        availablePeripherals = bluetoothFlow.retrievePeripherals()
        self.tableView.reloadData()
        self.tableView.selectRow(at: selectedCell, animated: true, scrollPosition: UITableView.ScrollPosition .none)
        print("Still loading")
        if(search){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                guard self.search != false else { return } // Asynch task should stop
                self.refreshPeripheralsList()
            })
        }
    }
    
    @IBAction func connect(_ sender: Any) {
        guard selectedPeripheral != nil else { return }
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        self.performSegue(withIdentifier: "PairingConnection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BluetoothPairingConnectViewController {
            self.search = false
            destination.selectedPeripheral = self.selectedPeripheral
        }
    }
    
}

extension BluetoothPairingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Peripherals")
        cell.textLabel?.text = availablePeripherals[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
        selectedPeripheral = availablePeripherals[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
