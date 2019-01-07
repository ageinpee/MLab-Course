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
    
    func goUp() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard bluetoothFlow.paired else { return }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.writeCharacteristic
            return
        }
        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m1In)
        bluetooth.connectedPeripheral!.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    func goDown() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard bluetoothFlow.paired else { return }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.writeCharacteristic
            return
        }
        let moveDown = self.remoteControlConfig.getKeycode(name: keycode.m1Out)
        bluetooth.connectedPeripheral!.writeValue(moveDown, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
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
