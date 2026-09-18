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

    init(id: UUID = UUID(), modeID: String, score: Int, duration: Int, date: Date) {
        self.id = id
        self.modeID = modeID
        self.score = score
        self.duration = duration
        self.date = date
    }

    var tapsPerSecond: Double {
        return Double(score) / Double(max(duration, 1))
    }

    var modeDisplayName: String {
        return GameMode.mode(forID: modeID)?.displayName ?? modeID
    }
}
