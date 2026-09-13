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

- State: monitoring / coordination; no active A mathematical implementation deliverable
- Mathematical frontier: `S1.1.Theorem1(ii)`
- Completed design / coordination checkpoints:
  - #6 — canonical statement contract completed
  - #11 / PR #12 — lane split and Interpretation/progress synchronization completed
  - #14 / PR #15 — transition of A handoff to steady monitoring state completed
  - E #8 / PR #13 — post-#5 lane-status / integration cleanup completed
- Current parallel owners:
  - B #7 — Lean statement / proof
  - C #9 — Blueprint / independent exposition
  - D #10 — mathlib research
- E status: ready / monitoring; take a focused Theorem 1(ii) cross-layer integration task only when B #7 and C #9 artifacts are ready
- Next A action: monitor #7/#9/#10 for statement drift, ownership conflicts, cross-lane dependency changes, and shared-hotspot contention. Do not create work merely to keep A busy.
- Integration routing: when B/C artifacts for Theorem 1(ii) are ready, create or route a focused E integration task for cross-layer verification if one does not already exist.
- Blockers: none
- Shared hotspots reserved by A: none

## Theorem 1(ii) coordination contract

The semantic source of truth is #6. In summary, for prime `p`, positive `f`, `q = p^f`, and a fixed algebraically closed field `Ω` of characteristic `p`, the target requires:

- existence of a subfield of `Ω` with exactly `q` elements;
- uniqueness of that subfield inside the fixed ambient `Ω`;
- equality of its carrier with the set of `x : Ω` satisfying `x^q = x`, equivalently the roots of `X^q - X`.

Abstract uniqueness up to field isomorphism belongs to Theorem 1(iii), not this target.

## Monitoring rules

- If B/C interpret the target differently from #6, stop the affected work and route `BLOCKED: CROSS-LANE-STATEMENT-DRIFT` to A.
- If two lanes claim the same deliverable or shared hotspot, do not resolve it by concurrent edits; route the conflict through A.
- D findings are advisory; B must still verify exact theorem assumptions and theorem strength before use.
- Do not advance to Theorem 1(iii) merely because A is idle. The current target should reach a stable integrated state first unless the dependency graph is explicitly changed.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdをsource of truthとして再確認し、設計・Issue分割・ownership・dependency管理を進めて。B/C/D/Eの実装は奪わないで。`
