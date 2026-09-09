//
//  GameLogic.swift
//  Second App
//
//  Pure, SwiftUI-free game rules extracted from ContentView so they can be
//  reasoned about (and eventually unit-tested) without a running app.
//

import Foundation

enum GameLogic {
    static let startingTime = 30
    static let highScoreKey = "com.jojeco.SecondApp.highScore"

    struct RoundOutcome: Equatable {
        let highScore: Int
        let isNewHighScore: Bool
    }

    static func resolveRound(score: Int, previousHighScore: Int) -> RoundOutcome {
        let isNewHighScore = score > previousHighScore
        let highScore = max(score, previousHighScore)
        return RoundOutcome(highScore: highScore, isNewHighScore: isNewHighScore)
    }

    enum TimeUrgency {
        case normal
        case warning
        case critical
    }

    static func urgency(forTimeRemaining t: Int) -> TimeUrgency {
        if t <= 5 {
            return .critical
        } else if t <= 10 {
            return .warning
        } else {
            return .normal
        }
    }
}
