//
//  ArduinoBLEUUID.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import Foundation
import CoreBluetooth

enum ArduinoBLEUUID {
    static let service = CBUUID(string: "FFE0")
    static let tempChar = CBUUID(string: "FFE1")
    static let lightChar = CBUUID(string: "FFE2")
}
