//
//  GameOverView.swift
//  Second App
//
//  The Game Over summary stack, extracted verbatim from ContentView.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    let highScore: Int
    let isNewHighScore: Bool
    let modeName: String
    let tapsPerSecond: Double
    let comparison: GameLogic.ScoreComparison?

    var body: some View {
        VStack(spacing: 8) {
            Text("Game Over")
                .font(.title)
                .fontWeight(.bold)
            Text(modeName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Final Score: \(score)")
                .font(.title2)
            Text(String(format: "%.1f taps/sec", tapsPerSecond))
                .font(.subheadline)
            if let comparison, let caption = comparison.caption {
                Text(caption).font(.caption).foregroundColor(comparison.color).fontWeight(comparison.fontWeight)
            }
            Text("High Score: \(highScore)")
                .font(.headline)
            if isNewHighScore {
                Text("New High Score!")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }
}

extension GameLogic.ScoreComparison {
    var caption: String? {
        switch self {
        case .newBest(let by):
            return "+\(by) over your previous best"
        case .tied:
            return "Tied your best!"
        case .short(let by):
            return "\(by) short of your best"
        case .firstScore:
            return nil
        }
    }

    var color: Color {
        switch self {
        case .newBest:
            return .orange
        case .tied:
            return .accentColor
        case .short, .firstScore:
            return .secondary
        }
    }

    var fontWeight: Font.Weight? {
        switch self {
        case .newBest:
            return .semibold
        case .tied, .short, .firstScore:
            return nil
        }
    }
}
