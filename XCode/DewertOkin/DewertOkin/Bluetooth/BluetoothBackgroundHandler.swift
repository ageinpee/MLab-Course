//
//  BluetoothBackgroundHandler.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreData

class BluetoothBackgroundHandler: BluetoothCoordinator {
    
    let remoteController = RemoteControlConfig()
    var onceConnectedPeripherals = [Devices]()
    var availablePeripherals = [CBPeripheral]()
    
    override func reconnect() -> CBPeripheral? {
        fetchDevices()
        guard bluetoothService?.centralManager.state == .poweredOn else { return nil }
        guard pairing != true else { return nil }
        guard paired != true else { return nil }
        guard onceConnectedPeripherals != [] else { return nil }
        availablePeripherals = bluetoothService?.retrievePeripherals() ?? []
        guard availablePeripherals != [] else { return nil } // Display no devices in range
        
        // Filter all peripherals for once connected peripherals
        availablePeripherals = availablePeripherals.filter {
            for devices in onceConnectedPeripherals {
                return devices.uuid == ($0.identifier.uuidString)
            }
            return false
        }
        
        // Connect to the last connected peripheral
        return availablePeripherals.last
    }
    
    override func retrievePeripherals() -> [CBPeripheral] {
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            return []
        }
        let peripherals = self.bluetoothService?.retrievePeripherals()
        return peripherals!
    }
    
    override func isInRange(uuid: String?) -> Bool {
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            return false
        }
        let peripherals = retrievePeripherals()
        for peripheral in peripherals {
            if peripheral.identifier.uuidString == uuid {
                return true
            }
        }
        return false
    }
    
    override func getPeripheralWithUUID(uuid: String?) -> CBPeripheral? {
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            return nil
        }
        let peripherals = retrievePeripherals()
        for peripheral in peripherals {
            if peripheral.identifier.uuidString == uuid {
                return peripheral
            }
        }
        return nil
    }
    
    override func checkStatus() -> Bool {
        guard bluetoothService?.centralManager.state == .poweredOn else { return false }
        guard pairing != true else { return false }
        guard paired != true else { return true }
        guard bluetoothService?.connectedPeripheral != nil else { return false }
        return true
    }
    
    func fetchDevices() {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            onceConnectedPeripherals = savedDevices
        } catch {
            print("Couldn't update the Devices, reload!")
        }
    }
    
}
