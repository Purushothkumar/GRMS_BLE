//
//  BluetoothManager.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, BluetoothServiceProtocol {
    @Published var isConnected = false
    @Published var temperature: String = "--"
    @Published var lightStatus: String = "Unknown"

    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    private var peripheral: CBPeripheral?

    private var tempChar: CBCharacteristic?
    private var lightChar: CBCharacteristic?

    func connect() {
        guard centralManager.state == .poweredOn, peripheral == nil else { return }
        centralManager.scanForPeripherals(withServices: [ArduinoBLEUUID.service])
    }

    func readTemperature() {
        guard let char = tempChar else { return }
        peripheral?.readValue(for: char)
    }

    func readLightStatus() {
        guard let char = lightChar else { return }
        peripheral?.readValue(for: char)
    }

    func enableNotifications() {
        if let tempChar = tempChar, tempChar.properties.contains(.notify) {
            peripheral?.setNotifyValue(true, for: tempChar)
        }
        if let lightChar = lightChar, lightChar.properties.contains(.notify) {
            peripheral?.setNotifyValue(true, for: lightChar)
        }
    }

    func sendTemperatureCommand(_ command: String) {
        guard let char = tempChar, char.properties.contains(.write) || char.properties.contains(.writeWithoutResponse) else { return }
        peripheral?.writeValue(Data(command.utf8), for: char, type: .withResponse)
    }

    func sendLightCommand(_ command: String) {
        guard let char = lightChar, char.properties.contains(.write) || char.properties.contains(.writeWithoutResponse) else { return }
        peripheral?.writeValue(Data(command.utf8), for: char, type: .withResponse)
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            if central.state == .poweredOn {
                self.connect()
            } else {
                self.isConnected = false
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        centralManager.stopScan()
        peripheral.delegate = self
        centralManager.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DispatchQueue.main.async {
            self.isConnected = true
        }
        peripheral.discoverServices([ArduinoBLEUUID.service])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        self.peripheral = nil
        self.connect()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([ArduinoBLEUUID.tempChar, ArduinoBLEUUID.lightChar], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for char in service.characteristics ?? [] {
            if char.uuid == ArduinoBLEUUID.tempChar {
                tempChar = char
            } else if char.uuid == ArduinoBLEUUID.lightChar {
                lightChar = char
            }
        }
        enableNotifications()
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil, let data = characteristic.value else { return }

        let value = String(data: data, encoding: .utf8) ?? "--"
        DispatchQueue.main.async {
            if characteristic.uuid == ArduinoBLEUUID.tempChar {
                self.temperature = value
            } else if characteristic.uuid == ArduinoBLEUUID.lightChar {
                self.lightStatus = value
            }
        }
    }
}
