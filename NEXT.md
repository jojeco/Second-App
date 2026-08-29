# Next increments

- Extract game state (score, timeRemaining, gameActive, timer, high score logic) into an `ObservableObject` (or `@Observable`) model so `ContentView` becomes purely presentational and the tick/round-end logic is unit-testable in isolation.
- Add a countdown color warning (e.g. text turns red/orange) once `timeRemaining` drops under 10s, for a bit of urgency feedback without changing the 30s round length or scoring rule.
- Modernize `ContentView_Previews` to the `#Preview` macro once the project's minimum deployment target supports it.
- Pull the pure game logic (tick decrement, round-end/high-score decision) into small free functions so they can be covered by XCTest without needing a running app or a real `Timer`.
