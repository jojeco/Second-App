# Next increments

- Add a test target to the .xcodeproj so `GameLogic.summarize`, `trimmed` and `resolveRound` can be unit-tested; `GameStatsStore` already accepts an injected `UserDefaults` for suite-based tests.
- Persist the last-selected `GameMode` so the app reopens in the mode the player last used.
- Add a per-mode filter to the Stats sheet (the store's `rounds(for:)` already takes an optional mode).
- Consider a lightweight round-detail view showing taps/sec trend across the stored history.
