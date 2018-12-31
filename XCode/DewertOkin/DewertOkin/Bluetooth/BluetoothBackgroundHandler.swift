//
//  BluetoothBackgroundHandler.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothBackgroundHandler: BluetoothCoordinator {
    
    let remoteController = RemoteControlConfig()
    var availablePeripherals = [CBPeripheral?]()
    
    override func reconnect() {
        guard bluetoothService?.centralManager.state == .poweredOn else { return }
        guard pairing != true else { return }
        guard paired != true else { return }
        let onceConnectedPeripherals = defaults.stringArray(forKey: "Peripheral")
        guard onceConnectedPeripherals != [] else { return }
        availablePeripherals = bluetoothService?.retrievePeripherals() ?? []
        guard availablePeripherals != [] else { return } // Display no devices in range
        
        // Filter all peripherals for once connected peripherals
        availablePeripherals = availablePeripherals.filter { (onceConnectedPeripherals?.contains(($0?.identifier.uuidString)!))! }
        
        // Connect to the last connected peripheral
        self.connect(peripheral: availablePeripherals.last as! CBPeripheral, completion: {_ in })
    }
    
}
