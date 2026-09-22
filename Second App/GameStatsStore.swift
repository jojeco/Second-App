//
//  GameStatsStore.swift
//  Second App
//
//  Persists per-mode high scores and a newest-first round history as a single
//  Codable archive in UserDefaults. UserDefaults is injectable so the store can
//  be tested against a throwaway suite.
//

import Foundation

struct StatsArchive: Codable, Equatable {
    var version: Int
    var highScores: [String: Int]
    var rounds: [RoundRecord]
    // Optional with a default: synthesized Decodable uses decodeIfPresent, so
    // pre-existing v1 JSON blobs (no "lifetime" key) decode cleanly instead of
    // throwing keyNotFound. Do not make this non-optional.
    var lifetime: LifetimeTotals? = nil

    static let empty = StatsArchive(version: 1, highScores: [:], rounds: [])
}

final class GameStatsStore {
    static let archiveKey = "com.jojeco.SecondApp.stats.v1"

    private let defaults: UserDefaults
    private(set) var archive: StatsArchive

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        var loaded = StatsArchive.empty
        if let data = defaults.data(forKey: GameStatsStore.archiveKey),
           let decoded = try? JSONDecoder().decode(StatsArchive.self, from: data) {
            loaded = decoded
        }

        // Migrate the pre-modes single high score into Classic.
        let legacy = defaults.integer(forKey: GameLogic.highScoreKey)
        loaded.highScores["classic"] = max(loaded.highScores["classic"] ?? 0, legacy)
        loaded = GameLogic.migrated(archive: loaded, legacyHighScore: legacy)
        self.archive = loaded
    }

    func highScore(for mode: GameMode) -> Int {
        return archive.highScores[mode.rawValue] ?? 0
    }

    /// Newest-first. Pass nil for every mode.
    func rounds(for mode: GameMode?) -> [RoundRecord] {
        guard let mode = mode else { return archive.rounds }
        return archive.rounds.filter { $0.modeID == mode.rawValue }
    }

    @discardableResult
    func record(round: RoundRecord, mode: GameMode) -> GameLogic.RoundOutcome {
        let outcome = GameLogic.resolveRound(score: round.score, previousHighScore: highScore(for: mode))
        archive.highScores[mode.rawValue] = outcome.highScore
        // Deliberate decision: a zero-tap round counts toward nothing — not
        // the stored history, not the lifetime totals. The high-score update
        // above still runs unconditionally, but a score of 0 can never beat
        // an existing high score, so this can't manufacture a spurious one.
        if GameLogic.shouldRecord(round: round) {
            archive.rounds.insert(round, at: 0)
            archive.rounds = GameLogic.trimmed(rounds: archive.rounds)
            archive.lifetime = GameLogic.accumulate(totals: archive.lifetime ?? .empty, round: round)
        }
        persist()
        if mode == .classic {
            // Keep the legacy key in sync for anything still reading it.
            defaults.set(outcome.highScore, forKey: GameLogic.highScoreKey)
        }
        return outcome
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(archive) else { return }
        defaults.set(data, forKey: GameStatsStore.archiveKey)
    }
}
