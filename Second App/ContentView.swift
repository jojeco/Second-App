import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            // Game Title
            Text("Tap Game!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

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
                    isNewHighScore: viewModel.isNewHighScore
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
