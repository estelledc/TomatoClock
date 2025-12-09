// Cat view model
// Created by Copilot

import Foundation
import Combine

final class CatViewModel: ObservableObject {
    @Published private(set) var profile: CatProfile

    init(name: String = "小猫") {
        self.profile = CatProfile(name: name, mood: .idle)
    }

    func updateMood(for session: PomodoroSession) {
        switch (session.type, session.state) {
        case (.focus, .running):
            profile.mood = .focusing
        case (.shortBreak, .running), (.longBreak, .running):
            profile.mood = .resting
        case (.focus, .finished):
            profile.mood = .celebrating
        default:
            profile.mood = .idle
        }
    }

    var statusMessage: String {
        switch profile.mood {
        case .idle:
            return "准备好一起专注了吗？"
        case .focusing:
            return "小猫正安静陪你专心工作~"
        case .resting:
            return "辛苦啦，休息一下，陪小猫玩会儿~"
        case .celebrating:
            return "太棒了！又完成一个番茄！"
        }
    }
}
