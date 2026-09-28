# Next increments

- Add a test target to the .xcodeproj so `GameLogic.accumulate`, `summarize(totals:)`, `migrated`, `shouldRecord` and `resolveRound` can be unit-tested; `GameStatsStore` already accepts an injected `UserDefaults` for suite-based tests.
- Persist the last-selected `GameMode` so the app reopens in the mode the player last used.
- Add a per-mode filter to the Stats sheet — `GameLogic.summarize(rounds:)` (kept alive for exactly this) and the store's `rounds(for:)` already take an optional mode; a per-mode lifetime summary would need a `[String: LifetimeTotals]` keyed by mode instead of one global `LifetimeTotals`.
- `bestTapsPerSecond` (both windowed and lifetime) is global across modes, so Sprint's short duration dominates it — pre-existing, still out of scope, but worth fixing alongside the per-mode filter above.
