//
//  GameViewModel.swift
//  Second App
//
//  Holds all game state for ContentView so the view itself stays purely
//  presentational. Wraps GameLogic's pure functions with Timer/UserDefaults
//  side effects.
//

import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var score = 0
    @Published private(set) var timeRemaining = GameLogic.startingTime
    @Published private(set) var gameActive = true
    @Published private(set) var isNewHighScore = false
    @Published private(set) var highScore: Int

    private var timer: Timer?
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.highScore = defaults.integer(forKey: GameLogic.highScoreKey)
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

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
            let outcome = GameLogic.resolveRound(score: score, previousHighScore: highScore)
            highScore = outcome.highScore
            isNewHighScore = outcome.isNewHighScore
            defaults.set(highScore, forKey: GameLogic.highScoreKey)
            gameActive = false
        }
    }

    func reset() {
        score = 0
        timeRemaining = GameLogic.startingTime
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
