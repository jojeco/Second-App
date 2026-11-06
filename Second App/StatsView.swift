//
//  StatsView.swift
//  Second App
//
//  Sheet showing lifetime totals (accumulated over every recorded round, never
//  trimmed) and the most recent rounds from the stored history window.
//

import SwiftUI

struct StatsView: View {
    let summary: GameLogic.StatsSummary
    let modeSummaries: [GameMode: GameLogic.StatsSummary]
    let rounds: [RoundRecord]

    @State private var filter: GameMode? = nil
    @Environment(\.dismiss) private var dismiss

    private var displayedSummary: GameLogic.StatsSummary {
        guard let filter = filter else { return summary }
        return modeSummaries[filter] ?? .zero
    }

    private var displayedRounds: [RoundRecord] {
        guard let filter = filter else { return rounds }
        return rounds.filter { $0.modeID == filter.rawValue }
    }

    var body: some View {
        NavigationStack {
            List {
                Picker("Filter", selection: $filter) {
                    Text("All").tag(GameMode?.none)
                    ForEach(GameMode.allCases) { mode in
                        Text(mode.displayName).tag(Optional(mode))
                    }
                }
                .pickerStyle(.segmented)

                Section("Overview") {
                    LabeledContent("Rounds played", value: "\(displayedSummary.roundsPlayed)")
                    LabeledContent("Total taps", value: "\(displayedSummary.totalTaps)")
                    LabeledContent("Best score", value: "\(displayedSummary.bestScore)")
                    LabeledContent("Average score", value: String(format: "%.1f", displayedSummary.averageScore))
                    LabeledContent("Best taps/sec", value: String(format: "%.1f", displayedSummary.bestTapsPerSecond))
                }

                Section("Recent Rounds") {
                    if displayedRounds.isEmpty {
                        if let filter = filter {
                            Text("No \(filter.displayName) rounds played yet.")
                                .foregroundColor(.secondary)
                        } else {
                            Text("No rounds played yet.")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ForEach(displayedRounds) { round in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(round.modeDisplayName)
                                        .font(.headline)
                                    Text(round.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    if let comparison = round.comparison, let caption = comparison.caption {
                                        Text(caption).font(.caption2).foregroundColor(comparison.color).fontWeight(comparison.fontWeight)
                                    }
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
