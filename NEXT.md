# Next increments

- Add a test target to the .xcodeproj so `GameLogic.accumulate`, `summarize(totals:)`, `migrated`, `migratedPerMode`, `shouldRecord` and `resolveRound` can be unit-tested; `GameStatsStore` already accepts an injected `UserDefaults` for suite-based tests.
- The Game Over screen now shows a comparison line (`GameLogic.compare`) against the previous per-mode best; consider also surfacing it in the Stats sheet per-round history, not just at round-end.
- `GameStatsStore.lastSelectedMode` persists the last-picked mode across launches; consider also remembering the mode the Stats sheet's filter was last set to.
- `GameOverView` now takes 6 params; if a 7th shows up, consider bundling round-end info (score, highScore, isNewHighScore, comparison) into a single small struct instead of growing the parameter list further.
- The comparison caption has no color/emphasis differentiation between newBest/tied/short — a future pass could style `newBest` closer to the "New High Score!" treatment.

Note: the timer used to start counting down on appear/reset/mode-switch before the player's first tap (worst for the 10s Sprint mode) — fixed via a `roundStarted` flag on `GameViewModel`; the round now stays frozen at full duration until the first tap arms it.

Note: the Stats sheet's "All" filter intentionally still reports one global `bestTapsPerSecond` across every mode, so Sprint's short duration dominates it — pre-existing behavior, left as-is on purpose. Picking a single mode in the filter shows that mode's own per-mode best taps/sec.
