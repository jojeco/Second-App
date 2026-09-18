//
//  GameViewModel.swift
//  Second App
//
//  Holds all game state for ContentView so the view itself stays purely
//  presentational. Wraps GameLogic's pure functions with Timer/UserDefaults
//  side effects (via GameStatsStore).
//

import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var score = 0
    @Published private(set) var timeRemaining = GameMode.classic.duration
    @Published private(set) var gameActive = true
    @Published private(set) var isNewHighScore = false
    @Published private(set) var highScore: Int
    @Published private(set) var mode: GameMode = .classic
    @Published private(set) var summary: GameLogic.StatsSummary
    @Published private(set) var recentRounds: [RoundRecord]

    private var timer: Timer?
    private let store: GameStatsStore

    init(defaults: UserDefaults = .standard) {
        let store = GameStatsStore(defaults: defaults)
        self.store = store
        self.highScore = store.highScore(for: .classic)
        self.summary = GameLogic.summarize(rounds: store.rounds(for: nil))
        self.recentRounds = store.rounds(for: nil)
    }

    func tap() {
        guard gameActive else { return }
        score += 1
    }

    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        gameActive = true
    }

    /// Switches mode. The round in progress is abandoned: nothing is recorded
    /// and no high score is written.
    func select(mode newMode: GameMode) {
        guard newMode != mode else { return }
        stop()
        mode = newMode
        highScore = store.highScore(for: newMode)
        reset()
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
            let round = RoundRecord(modeID: mode.rawValue, score: score, duration: mode.duration, date: Date())
            let outcome = store.record(round: round, mode: mode)
            highScore = store.highScore(for: mode)
            isNewHighScore = outcome.isNewHighScore
            summary = GameLogic.summarize(rounds: store.rounds(for: nil))
            recentRounds = store.rounds(for: nil)
            gameActive = false
        }
    }

    func reset() {
        score = 0
        timeRemaining = mode.duration
        isNewHighScore = false
        start()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        stop()
    }
}
