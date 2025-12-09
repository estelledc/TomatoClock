// Root container view with tab navigation
// Created by Copilot

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            PomodoroTimerView()
                .tabItem {
                    Label("专注", systemImage: "timer")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
    }
}
