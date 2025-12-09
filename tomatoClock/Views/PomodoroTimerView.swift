// Pomodoro timer main view
// Created by Copilot

import SwiftUI

struct PomodoroTimerView: View {
    @EnvironmentObject var timerVM: PomodoroTimerViewModel
    @EnvironmentObject var catVM: CatViewModel

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text(timerVM.formattedRemainingTime())
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                CatCompanionView(mood: catVM.profile.mood,
                                  statusText: catVM.statusMessage)

                Spacer()

                controlButtons
                    .padding(.bottom, 32)
            }
        }
        .onChange(of: timerVM.currentSession) { newSession in
            catVM.updateMood(for: newSession)
        }
        .onAppear {
            catVM.updateMood(for: timerVM.currentSession)
        }
    }

    private var background: some View {
        let color: Color
        switch timerVM.currentSession.type {
        case .focus:
            color = Color.orange.opacity(0.15)
        case .shortBreak, .longBreak:
            color = Color(.systemGray6)
        }
        return color.animation(.easeInOut(duration: 0.3), value: timerVM.currentSession.type)
    }

    private var controlButtons: some View {
        HStack(spacing: 24) {
            Button(action: {
                if timerVM.currentSession.state == .running {
                    timerVM.pause()
                } else {
                    timerVM.start()
                }
            }) {
                Text(timerVM.currentSession.state == .running ? "暂停" : "开始")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }

            Button(action: {
                timerVM.reset()
            }) {
                Text("重置")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 32)
    }
}
