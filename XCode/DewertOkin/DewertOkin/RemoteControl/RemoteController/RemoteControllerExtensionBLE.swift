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
    
}
