# Next increments

- Add a test target to the .xcodeproj so `GameLogic.accumulate`, `summarize(totals:)`, `migrated`, `migratedPerMode`, `shouldRecord` and `resolveRound` can be unit-tested; `GameStatsStore` already accepts an injected `UserDefaults` for suite-based tests.
- Persist the last-selected `GameMode` so the app reopens in the mode the player last used.

Note: the Stats sheet's "All" filter intentionally still reports one global `bestTapsPerSecond` across every mode, so Sprint's short duration dominates it — pre-existing behavior, left as-is on purpose. Picking a single mode in the filter shows that mode's own per-mode best taps/sec.
