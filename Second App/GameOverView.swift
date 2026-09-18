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
