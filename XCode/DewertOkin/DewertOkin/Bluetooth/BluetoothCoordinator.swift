//
//  BluetoothCoordinator.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 05.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothCoordinator {
    
    let defaults = UserDefaults.standard
    weak var bluetoothService = Bluetooth.sharedBluetooth
    var pairing = false
    var paired = false
    
    init(bluetoothService: Bluetooth) { self.bluetoothService = bluetoothService }
    
    func retrievePeripherals() -> [CBPeripheral] { return [] }
    
    func connect(peripheral: CBPeripheral, completion: @escaping (Bool) -> Void) { }
    
    func disconnected(failure: Bool) { }
    
    func reconnect() { }
    
    func ableToWrite() { }
    
    func waitForBluetooth(completion: @escaping (Bool) -> Void) { }
    
}
