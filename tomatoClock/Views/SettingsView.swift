// Settings view for pomodoro durations
// Created by Copilot

import SwiftUI

struct SettingsView: View {
    @AppStorage("focusDuration") private var focusDuration: Double = 25 * 60
    @AppStorage("shortBreakDuration") private var shortBreakDuration: Double = 5 * 60
    @AppStorage("longBreakDuration") private var longBreakDuration: Double = 15 * 60

    private func binding(for storage: Binding<Double>) -> Binding<Double> {
        Binding {
            storage.wrappedValue / 60.0
        } set: { newValue in
            storage.wrappedValue = max(1, newValue) * 60.0
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("专注时长 (分钟)")) {
                    Stepper(value: binding(for: $focusDuration), in: 5...120, step: 5) {
                        Text("专注：\(Int(focusDuration / 60)) 分钟")
                    }
                }

                Section(header: Text("休息时长 (分钟)")) {
                    Stepper(value: binding(for: $shortBreakDuration), in: 1...30, step: 1) {
                        Text("短休息：\(Int(shortBreakDuration / 60)) 分钟")
                    }

                    Stepper(value: binding(for: $longBreakDuration), in: 5...60, step: 5) {
                        Text("长休息：\(Int(longBreakDuration / 60)) 分钟")
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}
