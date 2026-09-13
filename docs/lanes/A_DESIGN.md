# A lane — Scheduler / Design

## Mission

Aはapproval gateではなく、B/C/D/Eが長く止まらずに形式化を進められるように **dependency graph・work queue・ownership conflict** を管理するschedulerです。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. このファイル
6. `FORMALIZATION_PROGRESS.md`
7. open Issue / PR / CI / branch / latest main

## Owned work

- queue health / dependency graph
- `READY` / `PREFLIGHT` / `STACKABLE` / `WAITING` の整合
- ambiguous statementの調整
- ownership / shared-hotspot conflict解消
- stale Issue / PR / handoff / progress drift修正
- dependency-safe work splitting / refill

Aは通常のLean/Blueprint implementationをworker poolから奪いません。

## Current handoff

- State: active scheduler coordination
- Active A Issue: #95
- Canonical A branch: `design/sync-post-94-live-95-v2`
- Current A PR: #101
- Superseded old A PR: #97
- Last completed A sync on main: #81 / PR #90, merge `6c39201ba0fd7fa2659d8fb499be836a20b5dfe5`

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements
- #74 / PR #94 — Chevalley Corollary 2
- #71 / PR #86 — Chapter 2 §1.1 project-local `Z_p`, main `2f4366622121ce0d56e76d8e9a41c25c6917da8b`

### Live ownership

- B: #78 `C1-Supp-GaussLemma`; #96 `C2S1.3-QpField`; #99 `C2S2.1-RootLiftingExistence`.
- C: #56 `S3.2-LegendreSymbol` / PR #98; #64 `S3.3-QuadraticReciprocity`.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric`.
- E: no mathematical ownership at latest check.
- Unclaimed: #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting`.

### Dependency / integration state

- #56/C published an explicit STACK-READY subset **for #64 only** at exact green head `45bde2eff8e75e901282151760b0c5dfc41a869a`, CI #198. Frozen declarations include the Legendre value/sign layers, multiplicativity, cast-back compatibility, `serre_theorem5_i`, and `serre_theorem5_ii`. A routed #64 to begin stacked implementation from exactly this SHA. #56 continues independently toward Theorem 5(iii), Blueprint, and final merge.
- #78/B needs a smaller subset already present at that head (`legendreValue` + sign↔field bridge), but the owner explicitly scoped the promise to #64 only. A requested a separate #78 promise; until then #78 remains WAITING.
- #71/B is DONE on main. The earlier withdrawn stack approval no longer constrains downstreams.
- #72/D has retargeted PR #92 to `main`; A routed latest-main resync/interface verification and resume. No statement drift has been reported.
- #89/D preflight is complete and fixes a source-shaped metric plan from project valuation/divisibility/topology; proof waits #72.
- #96/B preflight is complete. Algebraic `Q_p` should be `FractionRing (SerrePadicInt p)` after #72 supplies domain/valuation/unit decomposition; Proposition 4 needs a minimal #89 topology/neighborhood/density subset.
- #99 was seeded by A from §2.1 Proposition 5 and immediately claimed by B after #71 merged. Its hard dependency is satisfied, so B may move from preflight directly into implementation if polynomial reduction/evaluation introduces no new edge.
- #100 remains the separate Proposition 6 boundary: nonzero `Q_p` zero ↔ primitive `Z_p` zero ↔ primitive finite-level zeros; future proof uses #99 plus #72/#96.
- #102 was seeded from the next §2.2 Hensel boundary to restore two unclaimed safe candidates after #99 was claimed. Core proof is expected to need #72 valuation/congruence and #89 completeness, but source/API preflight is safe now.

### Shared-hotspot coordination

1. #98 / C is the next active root-integration candidate when the full §3.2 work item is ready; because main advanced via #86, final integration must be checked against latest main.
2. #92 / D is now ungated but should stabilize the algebraic proof interface before final Blueprint/root imports.
3. #99 / B should keep its Proposition 5 module isolated until its interface stabilizes, then coordinate root imports with the live queue.

A #95 v2 owns only:

- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- this file
- `FORMALIZATION_PROGRESS.md`

No worker mathematical file is edited.

### Queue health

Unclaimed safe capacity:

- #100 `C2S2.1-PrimitiveHomogeneousZeros` — PREFLIGHT; implementation waits #99/#72/#96 interfaces.
- #102 `C2S2.2-HenselLifting` — PREFLIGHT; implementation expected to wait #72/#89.

Owned executable/near-executable work includes #56/#64/#72/#99. Dependency-waiting but fully preflighted work includes #78/#89/#96. The worker pool therefore has parallel capacity without unrelated busywork.

### Next A actions

1. bring PR #101 to latest-head green with exactly the four A-owned files, then self-merge if main/live state is still represented;
2. monitor #64 stacked implementation against frozen #56 head and keep it isolated from later #56 declarations;
3. monitor #56 for a separate #78 freeze or merge, then route #78 to resume;
4. monitor #72 after #71 merge and #99 now that its hard gate is open;
5. refill only when #100/#102 are claimed or otherwise cease to be useful safe capacity.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
