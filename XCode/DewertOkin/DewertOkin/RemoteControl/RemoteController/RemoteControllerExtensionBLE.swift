//
//  RemoteControllerExtensionBLE.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth

extension RemoteController {
    
    func Connect() {
        // OLD CODE? bluetoothFlow has no member pair
//        self.bluetoothFlow.waitForPeripheral {
//            self.bluetoothFlow.pair { result in
//                self.peripheral = self.bluetooth.connectedPeripheral
//                self.characteristic = self.bluetooth.characteristic
//                self.paired = true
//            }
//        }
    }
    
    func moveHeadUp() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m1In)
    }
    
    func moveHeadDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m1Out)
    }
    
    func moveFeetUp() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m2In)
    }
    
    func moveFeetDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m2Out)
    }
    
    func triggerCommand(keycode: keycode) {
        let movement = self.remoteControlConfig.getKeycode(name: keycode)
        bluetooth.connectedPeripheral!.writeValue(movement, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    //    func goUpFeet() {
    //        guard self.bluetooth.bluetoothState == .poweredOn else {return}
    //        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m2In)
    //        peripheral?.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    //    }
    //
    //    func goDownFeet() {
    //        guard self.bluetooth.bluetoothState == .poweredOn else {return}
    //        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m2Out)
    //        peripheral?.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    //    }
}
