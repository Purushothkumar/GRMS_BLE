//
//  BluetoothServiceProtocol.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import Foundation

protocol BluetoothServiceProtocol {
    var isConnected: Bool { get }
    func connect()
    func sendTemperatureCommand(_ command: String)
    func sendLightCommand(_ command: String)
    func readTemperature()
    func readLightStatus()
}
