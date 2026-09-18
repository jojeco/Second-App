import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showingStats = false

    var body: some View {
        VStack {
            // Game Title
            Text("Tap Game!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Mode Picker
            Picker("Mode", selection: Binding(
                get: { viewModel.mode },
                set: { viewModel.select(mode: $0) }
            )) {
                ForEach(GameMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Text("Best (\(viewModel.mode.displayName)): \(viewModel.highScore)")
                .font(.headline)
                .padding(.top, 8)

            Spacer()

            // Score Display
            Text("Score: \(viewModel.score)")
                .font(.title)
                .padding()

            // Countdown Timer
            Text("Time: \(viewModel.timeRemaining)s")
                .font(.title2)
                .foregroundColor(color(for: GameLogic.urgency(forTimeRemaining: viewModel.timeRemaining)))
                .padding()

            Spacer()

            // Tap Button (while the round is active) / Game Over summary (once it ends)
            if viewModel.gameActive {
                TapButtonView(action: viewModel.tap)
            } else {
                GameOverView(
                    score: viewModel.score,
                    highScore: viewModel.highScore,
                    isNewHighScore: viewModel.isNewHighScore,
                    modeName: viewModel.mode.displayName,
                    tapsPerSecond: Double(viewModel.score) / Double(max(viewModel.mode.duration, 1))
                )
            }

            Spacer()

            // Reset Button
            Button(action: viewModel.reset) {
                Text("Reset Game")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()

            // Stats Button
            Button("Stats") {
                showingStats = true
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showingStats) {
            StatsView(summary: viewModel.summary, rounds: viewModel.recentRounds)
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }

    private func color(for urgency: GameLogic.TimeUrgency) -> Color {
        switch urgency {
        case .normal:
            return .primary
        case .warning:
            return .orange
        case .critical:
            return .red
        }
    }
}

#Preview {
    ContentView()
}
