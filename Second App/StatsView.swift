//
//  StatsView.swift
//  Second App
//
//  Sheet showing totals over the stored round history (last 20 rounds) and the most recent rounds.
//

import SwiftUI

struct StatsView: View {
    let summary: GameLogic.StatsSummary
    let rounds: [RoundRecord]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    LabeledContent("Rounds played", value: "\(summary.roundsPlayed)")
                    LabeledContent("Total taps", value: "\(summary.totalTaps)")
                    LabeledContent("Best score", value: "\(summary.bestScore)")
                    LabeledContent("Average score", value: String(format: "%.1f", summary.averageScore))
                    LabeledContent("Best taps/sec", value: String(format: "%.1f", summary.bestTapsPerSecond))
                }

                Section("Recent Rounds") {
                    if rounds.isEmpty {
                        Text("No rounds played yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(rounds) { round in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(round.modeDisplayName)
                                        .font(.headline)
                                    Text(round.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(round.score)")
                                        .font(.headline)
                                    Text(String(format: "%.1f taps/sec", round.tapsPerSecond))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stats")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
