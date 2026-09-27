# Hensel run notes

This branch is intentionally main-based and single-lane.  It should not consume the old parallel Hensel branches as active proof dependencies.  Old branches may be read only for recovery ideas after checking against latest main.

The current Lean scaffold has no `sorry` or theorem-strengthening shortcut.  It packages the exact source hypotheses/conclusions and a few direct helpers so the next commits can attack the one-step Newton proof locally.
