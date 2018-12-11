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
    var search = true
    
    var remoteControl = RemoteController()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        search = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshPeripheralsList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        search = false
    }
    
    func refreshPeripheralsList() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        availablePeripherals = bluetoothFlow.retrievePeripherals()
        DispatchQueue.main.async { self.tableView.reloadData() }
        print("Still loading")
        if(search){
            self.refreshPeripheralsList()
        }
    }
    
    @IBAction func connect(_ sender: Any) {
        availablePeripherals = bluetoothFlow.retrievePeripherals()
        DispatchQueue.main.async { self.tableView.reloadData() }
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
        print(availablePeripherals[indexPath.row].name)
    }
    
    
}
