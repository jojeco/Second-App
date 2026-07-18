import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameActive = true

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

            // Tap Button
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
            }
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                
                #imageLiteral(resourceName: "one-piece-chill-video-viaggio-wano-digital-art-v3-575447.jpg")
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
    }

    func startTimer() {
        gameActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                gameActive = false
            }
        }
    }

    func resetGame() {
        score = 0
        timeRemaining = 30
        startTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
