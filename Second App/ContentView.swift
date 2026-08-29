import SwiftUI

struct ContentView: View {
    private static let startingTime = 30
    private static let highScoreKey = "com.jojeco.SecondApp.highScore"

    @State private var score = 0
    @State private var timeRemaining = ContentView.startingTime
    @State private var gameActive = true
    @State private var isNewHighScore = false
    @State private var timer: Timer?
    @AppStorage(ContentView.highScoreKey) private var highScore = 0

    var body: some View {
        VStack {
            // Game Title
            Text("Tap Game!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()

            // Score Display
            Text("Score: \(score)")
                .font(.title)
                .padding()

            // Countdown Timer
            Text("Time: \(timeRemaining)s")
                .font(.title2)
                .padding()

            Spacer()

            // Tap Button (while the round is active) / Game Over summary (once it ends)
            if gameActive {
                Button(action: {
                    score += 1
                }) {
                    Text("Tap Me!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150, height: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(75)
                        .shadow(radius: 10)
                }
                .padding()
            } else {
                // Game Over summary
                VStack(spacing: 8) {
                    Text("Game Over")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Final Score: \(score)")
                        .font(.title2)
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

            Spacer()

            // Reset Button
            Button(action: resetGame) {
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
        .onAppear(perform: startTimer)
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { activeTimer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                activeTimer.invalidate()
                timer = nil
                isNewHighScore = score > highScore
                if isNewHighScore {
                    highScore = score
                }
                gameActive = false
            }
        }
        gameActive = true
    }

    func resetGame() {
        score = 0
        timeRemaining = ContentView.startingTime
        isNewHighScore = false
        startTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
