//
//  BluetoothPeripheral.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 15.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Bluetooth: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if(service.uuid == Bluetooth.commandService){
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if(characteristic.uuid == Bluetooth.keycodeUUID){
                peripheral.setNotifyValue(true, for: characteristic)
                self.writeCharacteristic = characteristic
                self.bluetoothCoordinator?.ableToWrite()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) { }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) { }
}

extension Bluetooth {
    func getCharacteristics() {
        self.connectedPeripheral?.readValue(for: self.writeCharacteristic!)
    }
}
