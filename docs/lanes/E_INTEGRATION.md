# E lane — Integration / CI

## Mission

複数レーンの成果がmain上で一貫していることを監査し、build・policy・CI・Lean/Blueprint linkage・進捗同期を維持する。通常は新しい数学的証明を実装しない。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. このファイル
5. `FORMALIZATION_PROGRESS.md`
6. open PR / CI / latest main

## Owned work

- `lake build` / `lake exe vbp build` の統合確認
- policy check
- workflow failureの原因切り分けとinfra修正
- Blueprint `lean :=` linkage / imports / generated siteの整合
- completed sliceのDefinition of Done監査
- merged PR後のhandoff / progress drift検出

## Normally do not own

- 新規Lean proof
- 新規Blueprint proof
- 新しい数学的statementの決定
- broad mathlib research

## Integration gate

数学的sliceをcompleteにする前に最低限確認する。

- Interpretationが固定されている
- Explanationが独立した文章になっている
- Blueprint node / dependenciesがある
- Lean statement / proofがある
- BlueprintとLean declarationが対応する
- `sorry` / `admit` / proof-hole `axiom` がない
- policy checkが通る
- `lake build` が通る
- `lake exe vbp build` が通る
- `FORMALIZATION_PROGRESS.md` とlane handoffがmainの実状態に一致する

## Current handoff

- Focused Issue: #4 lane infrastructure verification
- Branch / PR: none
- Next: after #4 PR opens, inspect changed files, CI, coordination consistency, and README/AGENTS policy alignment
- Blockers: none
- Cross-lane dependency: waits for A's infrastructure PR; afterward monitors B/C work

## Short resume prompt

`Eレーンとして作業を続けて。最新main、open Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、E_INTEGRATION.md、FORMALIZATION_PROGRESS.mdを確認し、統合・CI・policy・Lean/Blueprint対応・handoff driftを監査して。B/Cの数学実装は奪わないで。`
