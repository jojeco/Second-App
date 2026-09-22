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

    /// Folds one more finished round into the never-trimmed lifetime totals.
    static func accumulate(totals: LifetimeTotals, round: RoundRecord) -> LifetimeTotals {
        return LifetimeTotals(
            roundsPlayed: totals.roundsPlayed + 1,
            totalTaps: totals.totalTaps + round.score,
            bestScore: max(totals.bestScore, round.score),
            bestTapsPerSecond: max(totals.bestTapsPerSecond, round.tapsPerSecond)
        )
    }

    static func summarize(totals: LifetimeTotals) -> StatsSummary {
        let averageScore = Double(totals.totalTaps) / Double(max(totals.roundsPlayed, 1))
        return StatsSummary(
            roundsPlayed: totals.roundsPlayed,
            totalTaps: totals.totalTaps,
            bestScore: totals.bestScore,
            averageScore: averageScore,
            bestTapsPerSecond: totals.bestTapsPerSecond
        )
    }

    /// A round the player never tapped in shouldn't move any stat — not
    /// `roundsPlayed`, not `totalTaps`. Deliberate decision: a zero-score
    /// round counts toward nothing, it's excluded from both the stored
    /// history and the lifetime totals rather than treated as a real round
    /// with a score of zero.
    static func shouldRecord(round: RoundRecord) -> Bool {
        return round.score > 0
    }

    /// Seeds `archive.lifetime` the first time an archive is loaded that
    /// predates lifetime totals, by folding the (already-trimmed) round
    /// history and then widening `bestScore` with every known per-mode high
    /// score plus the legacy single high-score key, so a round that aged out
    /// of the trimmed window before this migration ran still counts.
    /// Gated on `archive.lifetime == nil`, not `version`, so re-running this
    /// on an already-migrated archive is a no-op.
    static func migrated(archive: StatsArchive, legacyHighScore: Int) -> StatsArchive {
        guard archive.lifetime == nil else { return archive }
        var migratedArchive = archive
        let folded = archive.rounds.reduce(LifetimeTotals.empty) { accumulate(totals: $0, round: $1) }
        var totals = folded
        totals.bestScore = max(folded.bestScore, archive.highScores.values.max() ?? 0, legacyHighScore)
        migratedArchive.lifetime = totals
        migratedArchive.version = 2
        return migratedArchive
    }
}
