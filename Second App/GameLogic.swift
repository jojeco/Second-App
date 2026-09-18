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
    /// Maximum number of rounds kept in the persisted history.
    static let historyLimit = 20

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

    struct StatsSummary: Equatable {
        let roundsPlayed: Int
        let totalTaps: Int
        let bestScore: Int
        let averageScore: Double
        let bestTapsPerSecond: Double

        static let zero = StatsSummary(
            roundsPlayed: 0,
            totalTaps: 0,
            bestScore: 0,
            averageScore: 0,
            bestTapsPerSecond: 0
        )
    }

    static func summarize(rounds: [RoundRecord]) -> StatsSummary {
        if rounds.isEmpty {
            return .zero
        }
        let roundsPlayed = rounds.count
        let totalTaps = rounds.reduce(0) { $0 + $1.score }
        let bestScore = rounds.map { $0.score }.max() ?? 0
        let bestTapsPerSecond = rounds.map { $0.tapsPerSecond }.max() ?? 0
        let averageScore = Double(totalTaps) / Double(roundsPlayed)
        return StatsSummary(
            roundsPlayed: roundsPlayed,
            totalTaps: totalTaps,
            bestScore: bestScore,
            averageScore: averageScore,
            bestTapsPerSecond: bestTapsPerSecond
        )
    }

    /// Keeps the newest `limit` rounds (history is stored newest-first).
    static func trimmed(rounds: [RoundRecord], limit: Int = historyLimit) -> [RoundRecord] {
        return Array(rounds.prefix(limit))
    }
}
