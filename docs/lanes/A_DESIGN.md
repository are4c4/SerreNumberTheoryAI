# A lane — Design / Coordination

## Mission

全体設計、数学的targetの境界、Issue分割、dependency、ownershipを管理する。B/C/D/Eの実装を奪わない。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. このファイル
5. `FORMALIZATION_PROGRESS.md`
6. open Issue / PR / CI / latest main

## Owned work

- project / chapter roadmap
- target id とstatement境界の確定
- focused Issueの作成・分割
- lane assignment
- dependency graph
- shared-hotspot coordination
- handoff driftの修正

## Normally do not own

- Lean proof本体
- Blueprint proof本体
- mathlib APIの深掘り調査
- CI failureの詳細修正

必要なら該当レーンへrouteする。

## Current handoff

- Focused Issue: #4 parallel AI lane coordination
- Branch: `infra/parallel-lane-coordination-4`
- PR: none yet
- Completed: initial repository bootstrap and first finite-field slice already exist on main
- Next: finish and merge #4; then split parent #2 follow-up into focused artifact Issues for Theorem 1(ii)
- Blockers: none
- Cross-lane dependency: B/C/D/E should not claim Theorem 1(ii) deliverables until focused Issues are created
- Shared hotspots: `AGENTS.md`, `README.md`, `FORMALIZATION_PROGRESS.md`, `.github/pull_request_template.md`

## Short resume prompt

`Aレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdをsource of truthとして再確認し、設計・Issue分割・ownership・dependency管理を進めて。B/C/D/Eの実装は奪わないで。`
