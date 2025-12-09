//
//  tomatoClockApp.swift
//  tomatoClock
//
//  Created by Jason on 2025/12/8.
//

import SwiftUI

@main
struct tomatoClockApp: App {
    @StateObject private var timerViewModel = PomodoroTimerViewModel()
    @StateObject private var catViewModel = CatViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(timerViewModel)
                .environmentObject(catViewModel)
        }
    }
}
