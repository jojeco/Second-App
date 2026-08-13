import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameActive = false
    @State private var gameOver = false
    @State private var tapScale: CGFloat = 1.0
    @State private var tapColor: Color = .blue
    @AppStorage("highScore") private var highScore = 0
    @State private var countdownTimer: Timer?

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Tap Game!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                HStack(spacing: 40) {
                    VStack {
                        Text("\(score)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    VStack {
                        Text("\(timeRemaining)s")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(timeRemaining <= 5 ? .red : .primary)
                            .animation(.default, value: timeRemaining)
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    VStack {
                        Text("\(highScore)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                        Text("Best")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 30)

                Spacer()

                if !gameOver {
                    Button(action: handleTap) {
                        Text(gameActive ? "TAP!" : "Start")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 160, height: 160)
                            .background(gameActive ? tapColor : Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: (gameActive ? tapColor : Color.green).opacity(0.4), radius: 12, x: 0, y: 6)
                            .scaleEffect(tapScale)
                    }
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: tapScale)
                    .padding()
                }

                Spacer()

                if !gameActive && !gameOver {
                    Text("Tap Start to play — 30 seconds on the clock!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }

            if gameOver {
                gameOverOverlay
            }
        }
    }

    var gameOverOverlay: some View {
        VStack(spacing: 24) {
            Text("Time's Up!")
                .font(.system(size: 36, weight: .bold))

            VStack(spacing: 8) {
                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.semibold)
                if score >= highScore && score > 0 {
                    Label("New Best!", systemImage: "star.fill")
                        .font(.headline)
                        .foregroundColor(.orange)
                } else {
                    Text("Best: \(highScore)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Button(action: resetGame) {
                Text("Play Again")
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(radius: 6)
            }
        }
        .padding(40)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 20)
    }

    func handleTap() {
        if !gameActive {
            startGame()
            return
        }
        score += 1
        withAnimation(.spring(response: 0.1, dampingFraction: 0.4)) {
            tapScale = 0.88
            tapColor = score % 2 == 0 ? .blue : .purple
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation { tapScale = 1.0 }
        }
    }

    func startGame() {
        score = 0
        timeRemaining = 30
        gameActive = true
        gameOver = false

        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                countdownTimer = nil
                gameActive = false
                gameOver = true
                if score > highScore {
                    highScore = score
                }
            }
        }
    }

    func resetGame() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        gameOver = false
        gameActive = false
        score = 0
        timeRemaining = 30
        tapScale = 1.0
        tapColor = .blue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
