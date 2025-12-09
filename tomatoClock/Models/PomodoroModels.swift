// Pomodoro core models
// Created by Copilot

import Foundation

enum SessionType {
    case focus
    case shortBreak
    case longBreak
}

enum SessionState {
    case idle
    case running
    case paused
    case finished
}

struct PomodoroSettings {
    var focusDuration: TimeInterval
    var shortBreakDuration: TimeInterval
    var longBreakDuration: TimeInterval
    var sessionsBeforeLongBreak: Int
}

struct PomodoroSession: Identifiable, Equatable {
    let id = UUID()
    var type: SessionType
    var state: SessionState
    var totalSeconds: Int
    var remainingSeconds: Int
}
