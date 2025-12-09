// Pomodoro timer view model
// Created by Copilot

import Foundation
import Combine

final class PomodoroTimerViewModel: ObservableObject {
    @Published var currentSession: PomodoroSession
    @Published var completedFocusSessions: Int = 0

    private var settings: PomodoroSettings
    private var timerCancellable: AnyCancellable?

    init(settings: PomodoroSettings = PomodoroSettings(focusDuration: 25 * 60,
                                                       shortBreakDuration: 5 * 60,
                                                       longBreakDuration: 15 * 60,
                                                       sessionsBeforeLongBreak: 4)) {
        self.settings = settings
        self.currentSession = PomodoroSession(type: .focus,
                                              state: .idle,
                                              totalSeconds: Int(settings.focusDuration),
                                              remainingSeconds: Int(settings.focusDuration))
    }

    func start() {
        guard currentSession.state == .idle || currentSession.state == .paused else { return }
        currentSession.state = .running

        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func pause() {
        guard currentSession.state == .running else { return }
        currentSession.state = .paused
        timerCancellable?.cancel()
    }

    func reset() {
        timerCancellable?.cancel()
        switch currentSession.type {
        case .focus:
            currentSession = PomodoroSession(type: .focus,
                                             state: .idle,
                                             totalSeconds: Int(settings.focusDuration),
                                             remainingSeconds: Int(settings.focusDuration))
        case .shortBreak:
            currentSession = PomodoroSession(type: .shortBreak,
                                             state: .idle,
                                             totalSeconds: Int(settings.shortBreakDuration),
                                             remainingSeconds: Int(settings.shortBreakDuration))
        case .longBreak:
            currentSession = PomodoroSession(type: .longBreak,
                                             state: .idle,
                                             totalSeconds: Int(settings.longBreakDuration),
                                             remainingSeconds: Int(settings.longBreakDuration))
        }
    }

    func skipToNextSession() {
        timerCancellable?.cancel()
        handleSessionFinished()
    }

    private func tick() {
        guard currentSession.state == .running else { return }
        if currentSession.remainingSeconds > 0 {
            currentSession.remainingSeconds -= 1
        }
        if currentSession.remainingSeconds <= 0 {
            currentSession.state = .finished
            timerCancellable?.cancel()
            handleSessionFinished()
        }
    }

    private func handleSessionFinished() {
        switch currentSession.type {
        case .focus:
            completedFocusSessions += 1
            // decide next: short or long break
            let isLongBreak = completedFocusSessions % settings.sessionsBeforeLongBreak == 0
            if isLongBreak {
                currentSession = PomodoroSession(type: .longBreak,
                                                 state: .idle,
                                                 totalSeconds: Int(settings.longBreakDuration),
                                                 remainingSeconds: Int(settings.longBreakDuration))
            } else {
                currentSession = PomodoroSession(type: .shortBreak,
                                                 state: .idle,
                                                 totalSeconds: Int(settings.shortBreakDuration),
                                                 remainingSeconds: Int(settings.shortBreakDuration))
            }
        case .shortBreak, .longBreak:
            currentSession = PomodoroSession(type: .focus,
                                             state: .idle,
                                             totalSeconds: Int(settings.focusDuration),
                                             remainingSeconds: Int(settings.focusDuration))
        }
    }

    func formattedRemainingTime() -> String {
        let minutes = currentSession.remainingSeconds / 60
        let seconds = currentSession.remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
