//
//  RoundRecord.swift
//  Second App
//
//  One finished round, stored (Codable) in the persisted history.
//

import Foundation

struct RoundRecord: Codable, Equatable, Identifiable {
    let id: UUID
    let modeID: String
    let score: Int
    let duration: Int
    let date: Date
    // The mode's high score just before this round was recorded, or nil for
    // rounds recorded before this field existed. Decodable's synthesized
    // decodeIfPresent handles the missing key in old archives automatically.
    let previousBest: Int?

    init(id: UUID = UUID(), modeID: String, score: Int, duration: Int, date: Date, previousBest: Int? = nil) {
        self.id = id
        self.modeID = modeID
        self.score = score
        self.duration = duration
        self.date = date
        self.previousBest = previousBest
    }

    var tapsPerSecond: Double {
        return Double(score) / Double(max(duration, 1))
    }

    var modeDisplayName: String {
        return GameMode.mode(forID: modeID)?.displayName ?? modeID
    }

    var comparison: GameLogic.ScoreComparison? {
        guard let previousBest else { return nil }
        return GameLogic.compare(score: score, previousHighScore: previousBest)
    }
}
