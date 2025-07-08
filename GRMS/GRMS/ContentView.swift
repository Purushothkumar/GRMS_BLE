//
//  ContentView.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ThermostatLightViewModel(bluetooth: BluetoothManager())

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.2), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("GRMS")
                    .font(.system(size: 40, weight: .bold, design: .rounded))

                // Thermostat Section
                VStack(spacing: 16) {
                    Text("Thermostat Control")
                        .font(.title2)
                        .bold()

                    Text("Temperature: \(viewModel.temperature) °C")
                        .font(.title3)

                    HStack(spacing: 20) {
                        PrimaryButton(title: "Increase", color: .orange, isEnabled: viewModel.isConnected, imageName: "plus") {
                            viewModel.increaseTemperature()
                        }
                        PrimaryButton(title: "Decrease", color: .orange, isEnabled: viewModel.isConnected, imageName: "minus") {
                            viewModel.decreaseTemperature()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 5))

                // Light Section
                VStack(spacing: 16) {
                    Text("Light Control")
                        .font(.title2)
                        .bold()

                    Text("Light Status: \(viewModel.lightStatus)")
                        .font(.title3)

                    HStack(spacing: 20) {
                        PrimaryButton(title: "Light ON", color: .green, isEnabled: viewModel.isConnected, imageName: "lightbulb.fill") {
                            viewModel.turnLightOn()
                        }
                        PrimaryButton(title: "Light OFF", color: .red, isEnabled: viewModel.isConnected, imageName: "lightbulb.slash.fill") {
                            viewModel.turnLightOff()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 5))

                // Status & Refresh
                VStack(spacing: 10) {

                    HStack(spacing: 8) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .foregroundColor(viewModel.isConnected ? .green : .red)

                        Text(viewModel.isConnected ? "Connected ✅" : "Connecting...")
                            .font(.headline)
                            .foregroundColor(viewModel.isConnected ? .green : .red)
                    }

                    PrimaryButton(title: "Refresh", color: .green, isEnabled: viewModel.isConnected, imageName: "arrow.clockwise") {
                        viewModel.fetchStatus()
                    }
                }
            }
            .padding()
        }
        .onAppear{ viewModel.fetchStatus() }
    }
}

#Preview {
    ContentView()
}
