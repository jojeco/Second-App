//
//  LifetimeTotals.swift
//  Second App
//
//  Running totals across every recorded round, accumulated once per round and
//  never trimmed. Backstops the Stats sheet so its "Best score" can't drift
//  below ContentView's per-mode "Best" once a round ages out of the trimmed
//  history window kept in StatsArchive.rounds (see GameLogic.accumulate).
//

import Foundation

struct LifetimeTotals: Codable, Equatable {
    var roundsPlayed: Int
    var totalTaps: Int
    var bestScore: Int
    var bestTapsPerSecond: Double

    static let empty = LifetimeTotals(
        roundsPlayed: 0,
        totalTaps: 0,
        bestScore: 0,
        bestTapsPerSecond: 0
    )
}
