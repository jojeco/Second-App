# Next increments

- Add a test target to the .xcodeproj so `GameLogic.accumulate`, `summarize(totals:)`, `migrated`, `migratedPerMode`, `shouldRecord` and `resolveRound` can be unit-tested; `GameStatsStore` already accepts an injected `UserDefaults` for suite-based tests.
- `GameStatsStore.lastSelectedMode` persists the last-picked mode across launches; consider also remembering the mode the Stats sheet's filter was last set to.
- `GameOverView` now takes 6 params; if a 7th shows up, consider bundling round-end info (score, highScore, isNewHighScore, comparison) into a single small struct instead of growing the parameter list further.
- The Stats sheet's Recent Rounds now shows each round's vs-previous-best caption via `RoundRecord.previousBest`/`.comparison`. Rounds recorded before this field existed have `previousBest == nil` and show no caption — intended, not a bug.
- Done: a new-best (or first-ever) round in the Stats rows now shows a small trophy icon next to the score instead of the long caption; `.tied`/`.short` captions are unchanged.

Note: the timer used to start counting down on appear/reset/mode-switch before the player's first tap (worst for the 10s Sprint mode) — fixed via a `roundStarted` flag on `GameViewModel`; the round now stays frozen at full duration until the first tap arms it.

Note: the Stats sheet's "All" filter intentionally still reports one global `bestTapsPerSecond` across every mode, so Sprint's short duration dominates it — pre-existing behavior, left as-is on purpose. Picking a single mode in the filter shows that mode's own per-mode best taps/sec.

Note: `GameLogic.urgency` thresholds now scale with the mode's `duration` so Sprint's 10s round doesn't show "warning" color for its entire length.
