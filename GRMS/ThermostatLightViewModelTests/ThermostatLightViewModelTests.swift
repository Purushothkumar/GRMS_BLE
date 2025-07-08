//
//  ThermostatLightViewModelTests.swift
//  ThermostatLightViewModelTests
//
//  Created by Purushothkumar on 08/07/25.
//

import XCTest
@testable import GRMS

final class ThermostatLightViewModelTests: XCTestCase {
    var viewModel: ThermostatLightViewModel!
    var mockBluetooth: MockBluetoothService!

    override func setUp() {
        super.setUp()
        mockBluetooth = MockBluetoothService()
        viewModel = ThermostatLightViewModel(bluetooth: mockBluetooth)
    }

    override func tearDown() {
        viewModel = nil
        mockBluetooth = nil
        super.tearDown()
    }

    func testInitialConnection() {
        XCTAssertTrue(mockBluetooth.isConnected)
    }

    func testIncreaseTemperatureSendsIncCommand() {
        viewModel.increaseTemperature()
        XCTAssertEqual(mockBluetooth.didSendTemperatureCommand, "inc")
    }

    func testDecreaseTemperatureSendsDecCommand() {
        viewModel.decreaseTemperature()
        XCTAssertEqual(mockBluetooth.didSendTemperatureCommand, "dec")
    }

    func testTurnLightOnSendsOnCommand() {
        viewModel.turnLightOn()
        XCTAssertEqual(mockBluetooth.didSendLightCommand, "on")
    }

    func testTurnLightOffSendsOffCommand() {
        viewModel.turnLightOff()
        XCTAssertEqual(mockBluetooth.didSendLightCommand, "off")
    }

    func testFetchStatusCallsReadMethods() {
        viewModel.fetchStatus()
        XCTAssertTrue(mockBluetooth.didReadTemperature)
        XCTAssertTrue(mockBluetooth.didReadLightStatus)
    }
}
class MockBluetoothService: BluetoothServiceProtocol {
    var isConnected: Bool = true
    var didSendTemperatureCommand: String?
    var didSendLightCommand: String?
    var didReadTemperature = false
    var didReadLightStatus = false

    func connect() {
        isConnected = true
    }

    func sendTemperatureCommand(_ command: String) {
        didSendTemperatureCommand = command
    }

    func sendLightCommand(_ command: String) {
        didSendLightCommand = command
    }

    func readTemperature() {
        didReadTemperature = true
    }

    func readLightStatus() {
        didReadLightStatus = true
    }
}
