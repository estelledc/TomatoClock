// Cat models
// Created by Copilot

import Foundation

enum CatMood {
    case idle
    case focusing
    case resting
    case celebrating
}

struct CatProfile {
    var name: String
    var mood: CatMood
}
