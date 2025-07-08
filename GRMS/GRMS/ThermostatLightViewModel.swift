//
//  ThermostatLightViewModel.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import Foundation
import Combine

class ThermostatLightViewModel: ObservableObject {
    @Published var isConnected = false
    @Published var temperature: String = "--"
    @Published var lightStatus: String = "Unknown"

    private var bluetooth: BluetoothServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(bluetooth: BluetoothServiceProtocol) {
        self.bluetooth = bluetooth

        if let manager = bluetooth as? BluetoothManager {
            manager.$isConnected
                .receive(on: RunLoop.main)
                .assign(to: \ThermostatLightViewModel.isConnected, on: self)
                .store(in: &cancellables)

            manager.$temperature
                .receive(on: RunLoop.main)
                .assign(to: \ThermostatLightViewModel.temperature, on: self)
                .store(in: &cancellables)

            manager.$lightStatus
                .receive(on: RunLoop.main)
                .assign(to: \ThermostatLightViewModel.lightStatus, on: self)
                .store(in: &cancellables)
        }

        bluetooth.connect()
    }

    func fetchStatus() {
        bluetooth.readTemperature()
        bluetooth.readLightStatus()
    }

    func increaseTemperature() {
        bluetooth.sendTemperatureCommand("inc")
    }

    func decreaseTemperature() {
        bluetooth.sendTemperatureCommand("dec")
    }

    func turnLightOn() {
        bluetooth.sendLightCommand("on")
    }

    func turnLightOff() {
        bluetooth.sendLightCommand("off")
    }
}
