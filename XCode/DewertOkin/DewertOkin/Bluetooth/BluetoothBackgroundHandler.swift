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
    var availablePeripherals = [CBPeripheral]()
    
    override func reconnect() -> CBPeripheral? {
        guard bluetoothService?.centralManager.state == .poweredOn else { return nil }
        guard pairing != true else { return nil }
        guard paired != true else { return nil }
        let onceConnectedPeripherals = defaults.stringArray(forKey: "Peripherals")
        guard onceConnectedPeripherals != [] else { return nil }
        availablePeripherals = bluetoothService?.retrievePeripherals() ?? []
        guard availablePeripherals != [] else { return nil } // Display no devices in range
        
        // Filter all peripherals for once connected peripherals
        availablePeripherals = availablePeripherals.filter { (onceConnectedPeripherals?.contains(($0.identifier.uuidString)))! }
        
        // Connect to the last connected peripheral
        return availablePeripherals.last
    }
    
}
